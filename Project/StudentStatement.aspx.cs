using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class StudentStatement : System.Web.UI.Page
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
                BindStatement();
            }
        }

        private void BindStatement()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string balanceSql = "SELECT ISNULL(CurrentBalance, 0) FROM Users WHERE UserID = @uid";
                using (SqlCommand balCmd = new SqlCommand(balanceSql, conn))
                {
                    balCmd.Parameters.AddWithValue("@uid", userId);
                    object result = balCmd.ExecuteScalar();
                    decimal balance = (result != null) ? Convert.ToDecimal(result) : 0;

                    lblCurrentBalance.Text = "RM " + balance.ToString("N2");
                }

                string sql = @"
                    SELECT 
                        i.InvoiceID, 
                        i.TotalAmount, 
                        i.Status, 
                        ISNULL(p.AmountPaid, 0) AS AmountPaid, 
                        p.PaymentDate,
                        ISNULL(adj.AdjDetails, 'No Adjustment') AS AdjDetails,
                        (i.TotalAmount + ISNULL(adj.TotalAdj, 0) - ISNULL(p.AmountPaid, 0)) AS FinalBalance
                    FROM Invoices i 
                    LEFT JOIN Payments p ON i.InvoiceID = p.InvoiceID 
                    LEFT JOIN (
                        SELECT 
                            InvoiceID, 
                            SUM(Amount) as TotalAdj,
                            STUFF((SELECT '<br/>' + Reason + ': ' + CAST(Amount AS VARCHAR)
                                   FROM AdjustmentNotes t2
                                   WHERE t1.InvoiceID = t2.InvoiceID
                                   FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 5, '') as AdjDetails
                        FROM AdjustmentNotes t1
                        GROUP BY InvoiceID
                    ) adj ON i.InvoiceID = adj.InvoiceID
                    WHERE i.StudentID = @uid";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvStatement.DataSource = dt;
                    gvStatement.DataBind();
                }
            }
        }

        protected void gvStatement_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string status = DataBinder.Eval(e.Row.DataItem, "Status").ToString();
                TableCell statusCell = e.Row.Cells[3];

                if (status.Equals("Pending", StringComparison.OrdinalIgnoreCase))
                {
                    statusCell.ForeColor = Color.Red;
                    statusCell.Font.Bold = true;
                }
                else if (status.Equals("Paid", StringComparison.OrdinalIgnoreCase))
                {
                    statusCell.ForeColor = Color.SeaGreen;
                    statusCell.Font.Bold = true;
                }
            }
        }
    }
}