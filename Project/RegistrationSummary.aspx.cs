using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Project
{
    public partial class RegistrationSummary : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EnrollmentDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                LoadRegistrationSummary();
            }
        }

        private void LoadRegistrationSummary()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string courseSql = @"
            SELECT c.CourseCode, c.CourseName, t.DayOfWeek, t.StartTime, t.EndTime, t.Venue
            FROM Enrollments e
            JOIN Courses c ON e.CourseID = c.CourseID
            JOIN Timetables t ON c.CourseID = t.CourseID
            WHERE e.StudentID = @uid AND e.Status = 'Active'";

                SqlCommand cmd = new SqlCommand(courseSql, conn);
                cmd.Parameters.AddWithValue("@uid", Session["UserID"]);

                string feeSql = "SELECT SUM(TotalAmount) FROM Invoices WHERE StudentID = @uid";
                SqlCommand feeCmd = new SqlCommand(feeSql, conn);
                feeCmd.Parameters.AddWithValue("@uid", Session["UserID"]);

                try
                {
                    conn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dtCourses = new DataTable();
                    da.Fill(dtCourses);

                    System.Text.StringBuilder html = new System.Text.StringBuilder();
                    string[] days = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" };

                    for (int hour = 8; hour <= 17; hour++)
                    {
                        TimeSpan currentTime = new TimeSpan(hour, 0, 0);
                        string timeSlotDisplay = hour.ToString("D2") + ":00";

                        html.Append("<tr>");
                        html.Append("<td style='background-color: #f2f2f2; color: #000; border: 1px solid #000;'><strong>" + timeSlotDisplay + "</strong></td>");

                        foreach (string day in days)
                        {
                            var foundCourse = dtCourses.AsEnumerable().FirstOrDefault(r =>
                                r.Field<string>("DayOfWeek") == day &&
                                r.Field<TimeSpan>("StartTime") <= currentTime &&
                                r.Field<TimeSpan>("EndTime") > currentTime);

                            if (foundCourse != null)
                            {
                                html.Append("<td style='background-color: #e6e6e6; color: #000; border: 1px solid #000; font-size: 11px; vertical-align: middle; padding: 5px;'>");
                                html.Append("<strong>" + foundCourse["CourseCode"] + "</strong><br/>");
                                html.Append("<small>" + foundCourse["Venue"] + "</small>");
                                html.Append("</td>");
                            }
                            else
                            {
                                html.Append("<td style='background-color: #fff; border: 1px solid #000;'></td>");
                            }
                        }
                        html.Append("</tr>");
                    }
                    ltlTimetable.Text = html.ToString();

                }
                catch (Exception ex)
                {
                    Response.Write("Error: " + ex.Message);
                }
            }
        }
    }
}