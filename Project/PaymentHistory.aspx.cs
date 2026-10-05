using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Project
{
    public partial class PaymentHistory : System.Web.UI.Page
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
                int currentUserID = Convert.ToInt32(Session["UserID"]);
                LoadPaymentHistory(currentUserID);
                LoadAdjustmentNotes(currentUserID);
            }
        }

        private void LoadPaymentHistory(int studentID)
        {

            string query = @"SELECT p.PaymentID, p.ReceiptNumber, p.PaymentDate, p.AmountPaid, p.PaymentMethod, p.InvoiceID 
                             FROM Payments p
                             INNER JOIN Invoices i ON p.InvoiceID = i.InvoiceID
                             WHERE i.StudentID = @StudentID
                             ORDER BY p.PaymentDate DESC";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StudentID", studentID);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvPaymentHistory.DataSource = dt;
                    gvPaymentHistory.DataBind();
                    gvPaymentHistory.Visible = true;
                    lblNoHistory.Visible = false;
                }
                else
                {
                    gvPaymentHistory.Visible = false;
                    lblNoHistory.Visible = true;
                }
            }
        }

        private void LoadAdjustmentNotes(int studentID)
        {
            string query = @"SELECT a.AdjustedDate, a.InvoiceID, a.Amount, a.Reason 
                             FROM AdjustmentNotes a
                             INNER JOIN Invoices i ON a.InvoiceID = i.InvoiceID
                             WHERE i.StudentID = @StudentID";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StudentID", studentID);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvAdjustments.DataSource = dt;
                    gvAdjustments.DataBind();
                    gvAdjustments.Visible = true;
                    lblNoAdjustments.Visible = false;
                }
                else
                {
                    gvAdjustments.Visible = false;
                    lblNoAdjustments.Visible = true;
                }
            }
        }
    }
}