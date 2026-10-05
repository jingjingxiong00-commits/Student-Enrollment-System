using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Project
{
    public partial class AddDropHistory : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EnrollmentDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadHistory();
            }
        }

        private void LoadHistory()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT h.LogDate, c.CourseCode, c.CourseName, h.ActionType 
                                 FROM AddDropHistory h
                                 INNER JOIN Courses c ON h.CourseID = c.CourseID
                                 WHERE h.StudentID = @StudentID
                                 ORDER BY h.LogDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvHistory.DataSource = dt;
                        gvHistory.DataBind();
                    }
                }
            }
        }
    }
}