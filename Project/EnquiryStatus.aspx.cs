using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Project
{
    public partial class EnquiryStatus : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EnrollmentDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEnquiries();
            }

            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        private void LoadEnquiries()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT EnquiryID, Subject, Message, Status, ISNULL(AdminReply, 'No reply yet') AS AdminReply " +
                               "FROM Enquiries WHERE StudentID = @uid";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@uid", Session["UserID"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvEnquiries.DataSource = dt;
                gvEnquiries.DataBind();

                if (dt.Rows.Count > 0)
                {
                    lblStatusResult.Text = "Enquiry records loaded successfully.";
                    lblStatusResult.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    lblStatusResult.Text = "No enquiry records found.";
                    lblStatusResult.ForeColor = System.Drawing.Color.Red;
                }
            }
        }
    }
}