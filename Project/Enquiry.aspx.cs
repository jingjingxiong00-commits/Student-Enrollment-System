using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Project
{
    public partial class Enquiry : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string subject = txtSubject.Text.Trim();
            string message = txtMessage.Text.Trim();

            if (subject == "" || message == "")
            {
                lblResult.Text = "Please fill in all fields.";
                lblResult.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["EnrollmentDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Enquiries (StudentID, Subject, Message, Status) VALUES (@StudentID, @Subject, @Message, @Status)";
                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@StudentID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@Subject", subject);
                cmd.Parameters.AddWithValue("@Message", message);
                cmd.Parameters.AddWithValue("@Status", "Pending");

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblResult.Text = "Enquiry submitted successfully.";
            lblResult.ForeColor = System.Drawing.Color.Green;

            txtSubject.Text = "";
            txtMessage.Text = "";
        }
    }
}