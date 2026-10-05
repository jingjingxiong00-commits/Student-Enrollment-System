using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Project
{
    public partial class Payment : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EnrollmentDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUnpaidInvoices();

                if (Request.QueryString["status"] == "success")
                {
                    string invID = Request.QueryString["InvID"];
                    if (decimal.TryParse(Request.QueryString["Amt"], out decimal amt))
                    {
                        string method = Request.QueryString["Method"];
                        decimal balUsed = 0;
                        decimal.TryParse(Request.QueryString["BalUsed"], out balUsed);

                        ProcessFinalPayment(invID, amt, method, balUsed);
                    }
                }
            }
        }

        private void LoadUnpaidInvoices()
        {
            int studentID = Convert.ToInt32(Session["UserID"]);
            string query = "SELECT InvoiceID, CreatedAt, TotalAmount, Status FROM Invoices WHERE StudentID = @StudentID AND Status = 'Unpaid'";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvInvoices.DataSource = dt;
                    gvInvoices.DataBind();
                    lblNoInvoices.Visible = dt.Rows.Count == 0;
                    gvInvoices.Visible = dt.Rows.Count > 0;
                }
            }
        }

        protected void gvInvoices_SelectedIndexChanged(object sender, EventArgs e)
        {
            string invoiceID = gvInvoices.SelectedDataKey.Value.ToString();
            decimal originalAmount = Convert.ToDecimal(gvInvoices.SelectedRow.Cells[2].Text);

            decimal userBalance = GetUserBalanceFromDB(Convert.ToInt32(Session["UserID"]));

            decimal deduction = Math.Min(originalAmount, userBalance);
            decimal finalPayable = originalAmount - deduction;

            lblInvoiceID.Text = invoiceID;
            lblOriginalAmount.Text = originalAmount.ToString("N2");
            lblBalanceDeduction.Text = deduction.ToString("N2");
            lblAmount.Text = finalPayable.ToString("N2");
            lblTotalUserBalance.Text = userBalance.ToString("N2");
            lblDueDate.Text = DateTime.Now.AddDays(7).ToString("dd/MM/yyyy");

            paymentDetails.Visible = true;
        }

        private decimal GetUserBalanceFromDB(int userId)
        {
            decimal balance = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT CurrentBalance FROM Users WHERE UserID = @uid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", userId);
                conn.Open();
                object res = cmd.ExecuteScalar();
                if (res != null && res != DBNull.Value) balance = Convert.ToDecimal(res);
            }
            return balance;
        }

        protected void btnProceedPayment_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(lblInvoiceID.Text) || string.IsNullOrEmpty(lblAmount.Text))
            {
                lblMessage.Text = "Please select an invoice first.";
                lblMessage.Visible = true;
                return;
            }

            string invID = lblInvoiceID.Text;
            string amt = lblAmount.Text;
            string balUsed = lblBalanceDeduction.Text;
            string method = rblPaymentMethod.SelectedValue;

            Response.Redirect($"DummyPayment.aspx?InvID={invID}&Amt={amt}&Method={method}&BalUsed={balUsed}");
        }

        private void ProcessFinalPayment(string invoiceID, decimal amountPaid, string method, decimal balanceUsed)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    if (balanceUsed > 0)
                    {
                        string updateBalanceSql = "UPDATE Users SET CurrentBalance = CurrentBalance - @deduction WHERE UserID = @uid";
                        using (SqlCommand cmdBal = new SqlCommand(updateBalanceSql, conn, transaction))
                        {
                            cmdBal.Parameters.AddWithValue("@deduction", balanceUsed);
                            cmdBal.Parameters.AddWithValue("@uid", userId);
                            cmdBal.ExecuteNonQuery();
                        }
                    }

                    string receiptNo = "REC" + DateTime.Now.ToString("yyyyMMddHHmmss");
                    string insertPayment = @"INSERT INTO Payments (InvoiceID, ReceiptNumber, PaymentDate, AmountPaid, PaymentMethod) 
                                             VALUES (@InvID, @Receipt, GETDATE(), @Amount, @Method)";

                    using (SqlCommand cmd = new SqlCommand(insertPayment, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@InvID", invoiceID);
                        cmd.Parameters.AddWithValue("@Receipt", receiptNo);
                        cmd.Parameters.AddWithValue("@Amount", amountPaid);
                        cmd.Parameters.AddWithValue("@Method", method);
                        cmd.ExecuteNonQuery();
                    }

                    string updateInvoice = "UPDATE Invoices SET Status = 'Paid' WHERE InvoiceID = @InvID";
                    using (SqlCommand cmd = new SqlCommand(updateInvoice, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@InvID", invoiceID);
                        cmd.ExecuteNonQuery();
                    }

                    transaction.Commit();

                    LoadUnpaidInvoices();
                    lblMessage.Text = $"Payment successful! Used RM {balanceUsed} from balance. Receipt: {receiptNo}";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Visible = true;
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblMessage.Text = "Error: " + ex.Message;
                    lblMessage.Visible = true;
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            paymentDetails.Visible = false;
        }
    }
}