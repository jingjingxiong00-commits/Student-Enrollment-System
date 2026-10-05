using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class CourseEnrollment : System.Web.UI.Page
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
                LoadEnrolledCourses(true);
                LoadAvailableCourses();
            }
        }

        private void LoadEnrolledCourses(bool isInitialLoad)
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT c.CourseCode, c.CourseName, c.Credits
                                 FROM Enrollments e
                                 INNER JOIN Courses c ON e.CourseID = c.CourseID
                                 WHERE e.StudentID = @StudentID AND e.Status = 'Active'";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvEnrolledCourses.DataSource = dt;
                        gvEnrolledCourses.DataBind();

                        if (isInitialLoad && dt.Rows.Count > 0)
                        {
                            lblMessage.Text = "You have already enrolled for this semester. Redirecting to Add/Drop section in 3 seconds...";
                            lblMessage.ForeColor = System.Drawing.Color.Red;

                            phEnrollmentContent.Visible = false;

                            string script = "setTimeout(function(){ window.location.href = 'Course_AddDrop.aspx'; }, 3000);";
                            ScriptManager.RegisterStartupScript(this, GetType(), "RedirectScript", script, true);
                        }
                    }
                }
            }
        }

        private void LoadAvailableCourses()
        {
            if (!gvAvailableCourses.Visible) return;

            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT CourseID, CourseCode, CourseName, Credits 
                                 FROM Courses 
                                 WHERE CourseID NOT IN (
                                     SELECT CourseID FROM Enrollments 
                                     WHERE StudentID = @StudentID AND Status = 'Active'
                                 )";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvAvailableCourses.DataSource = dt;
                        gvAvailableCourses.DataBind();
                    }
                }
            }
        }

        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserID"]);
            int currentEnrolledCredits = 0;
            int newlySelectedCredits = 0;
            int userSem = 1;
            int creditLimit = 20;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string userQuery = "SELECT CurrentSemester FROM Users WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(userQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", studentId);
                    object result = cmd.ExecuteScalar();
                    if (result != null) userSem = Convert.ToInt32(result);
                }

                if (userSem % 2 == 0) { creditLimit = 10; } else { creditLimit = 20; }

                string checkCredits = @"SELECT SUM(c.Credits) FROM Enrollments e 
                                JOIN Courses c ON e.CourseID = c.CourseID 
                                WHERE e.StudentID = @StudentID AND e.Status = 'Active'";
                using (SqlCommand cmd = new SqlCommand(checkCredits, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    object res = cmd.ExecuteScalar();
                    currentEnrolledCredits = (res != DBNull.Value && res != null) ? Convert.ToInt32(res) : 0;
                }

                foreach (GridViewRow row in gvAvailableCourses.Rows)
                {
                    CheckBox chk = (CheckBox)row.FindControl("chkSelect");
                    if (chk != null && chk.Checked)
                    {
                        newlySelectedCredits += Convert.ToInt32(row.Cells[3].Text);
                    }
                }

                if ((currentEnrolledCredits + newlySelectedCredits) > creditLimit)
                {
                    lblMessage.Text = $"Failed! Semester {userSem} limit is {creditLimit} credits. You tried to enroll {currentEnrolledCredits + newlySelectedCredits}.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                int enrolledCount = 0;
                decimal totalCost = 0;

                if (newlySelectedCredits > 0)
                {
                    foreach (GridViewRow row in gvAvailableCourses.Rows)
                    {
                        CheckBox chk = (CheckBox)row.FindControl("chkSelect");
                        if (chk != null && chk.Checked)
                        {
                            int courseId = Convert.ToInt32(gvAvailableCourses.DataKeys[row.RowIndex].Value);

                            string query = "INSERT INTO Enrollments (StudentID, CourseID, Status) VALUES (@StudentID, @CourseID, 'Active')";
                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@StudentID", studentId);
                                cmd.Parameters.AddWithValue("@CourseID", courseId);
                                cmd.ExecuteNonQuery();
                            }

                            string logQuery = "INSERT INTO AddDropHistory (StudentID, CourseID, ActionType) VALUES (@StudentID, @CourseID, 'Add')";
                            using (SqlCommand logCmd = new SqlCommand(logQuery, conn))
                            {
                                logCmd.Parameters.AddWithValue("@StudentID", studentId);
                                logCmd.Parameters.AddWithValue("@CourseID", courseId);
                                logCmd.ExecuteNonQuery();
                            }

                            string getCostQuery = "SELECT Cost FROM Courses WHERE CourseID = @CourseID";
                            using (SqlCommand costCmd = new SqlCommand(getCostQuery, conn))
                            {
                                costCmd.Parameters.AddWithValue("@CourseID", courseId);
                                totalCost += Convert.ToDecimal(costCmd.ExecuteScalar());
                            }
                            enrolledCount++;
                        }
                    }
                }

                if (enrolledCount > 0)
                {
                    string invoiceQuery = @"INSERT INTO Invoices (StudentID, TotalAmount, Status, CreatedAt) 
                                   VALUES (@StudentID, @Amount, 'Unpaid', GETDATE())";


                    using (SqlCommand invCmd = new SqlCommand(invoiceQuery, conn))
                    {
                        invCmd.Parameters.AddWithValue("@StudentID", studentId);
                        invCmd.Parameters.AddWithValue("@Amount", totalCost);
                        invCmd.ExecuteNonQuery();
                    }

                    lblMessage.Text = "Enrollment successful! Invoice generated.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;

                    LoadEnrolledCourses(false);
                    LoadAvailableCourses();
                }
                else
                {
                    lblMessage.Text = "Please select at least one course to enroll.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }
    }
}