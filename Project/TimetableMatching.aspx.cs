using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Project
{
    public partial class Timetable : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EnrollmentDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTimetable();
            }

            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        private void LoadTimetable()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        c.CourseCode,
                        c.CourseName,
                        t.DayOfWeek,
                        CONVERT(VARCHAR, t.StartTime, 108) AS StartTime,
                        CONVERT(VARCHAR, t.EndTime, 108) AS EndTime,
                        t.Venue
                    FROM Timetables t
                    INNER JOIN Courses c ON t.CourseID = c.CourseID";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTimetable.DataSource = dt;
                gvTimetable.DataBind();

                if (dt.Rows.Count > 0)
                {
                    lblTimetableResult.Text = "Timetable loaded successfully.";
                    lblTimetableResult.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    lblTimetableResult.Text = "No timetable records found.";
                    lblTimetableResult.ForeColor = System.Drawing.Color.Red;
                }
            }
        }
    }
}