using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Project
{
    public partial class ViewReceipt : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EnrollmentDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                string receiptID = Request.QueryString["ID"];
                if (!string.IsNullOrEmpty(receiptID))
                {
                    LoadReceiptData(receiptID);
                }
            }
        }
        private void LoadReceiptData(string rID)
        {
            string query = @"
        SELECT p.PaymentID, p.ReceiptNumber, p.PaymentDate, p.AmountPaid, p.PaymentMethod, p.InvoiceID,
               i.TotalAmount AS OriginalAmount, 
               u.Username AS StudentNum, u.FullName,
               (SELECT ISNULL(SUM(Amount), 0) FROM AdjustmentNotes WHERE InvoiceID = p.InvoiceID) AS TotalAdj
        FROM Payments p
        JOIN Invoices i ON p.InvoiceID = i.InvoiceID
        JOIN Users u ON i.StudentID = u.UserID
        WHERE p.PaymentID = @PID";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string currentInvoiceID = "";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PID", rID);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblStudentName.Text = dr["FullName"].ToString();
                            lblStudentID.Text = dr["StudentNum"].ToString();
                            lblReceiptNum.Text = dr["ReceiptNumber"].ToString();
                            lblDate.Text = Convert.ToDateTime(dr["PaymentDate"]).ToString("dd/MM/yyyy HH:mm");
                            lblMethod.Text = dr["PaymentMethod"].ToString();
                            lblInvoiceID.Text = dr["InvoiceID"].ToString();
                            lblOrg.Text = Convert.ToDecimal(dr["OriginalAmount"]).ToString("N2");
                            lblAdj.Text = Convert.ToDecimal(dr["TotalAdj"]).ToString("N2");
                            lblPaid.Text = Convert.ToDecimal(dr["AmountPaid"]).ToString("N2");
                            lblAmount.Text = Convert.ToDecimal(dr["AmountPaid"]).ToString("N2");

                            currentInvoiceID = dr["InvoiceID"].ToString();
                        }
                    }
                }

                if (!string.IsNullOrEmpty(currentInvoiceID))
                {
                    string adjQuery = "SELECT Amount, Reason FROM AdjustmentNotes WHERE InvoiceID = @InvID";
                    using (SqlCommand adjCmd = new SqlCommand(adjQuery, conn))
                    {
                        adjCmd.Parameters.AddWithValue("@InvID", currentInvoiceID);
                        SqlDataAdapter da = new SqlDataAdapter(adjCmd);
                        DataTable dtAdj = new DataTable();
                        da.Fill(dtAdj);
                        rptAdjustments.DataSource = dtAdj;
                        rptAdjustments.DataBind();
                    }
                }
            }
        }
    }
}