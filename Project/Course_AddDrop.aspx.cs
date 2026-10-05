using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class CourseAddDrop : System.Web.UI.Page
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
                LoadEnrolledCourses();
                LoadAvailableCourses();
            }
        }

        private void LoadEnrolledCourses()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT e.EnrollID, c.CourseID, c.CourseCode, c.CourseName, c.Credits
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
                    }
                }
            }
        }

        protected void gvEnrolledCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DropCourse")
            {
                int index = Convert.ToInt32(e.CommandArgument);

                int enrollId = Convert.ToInt32(gvEnrolledCourses.DataKeys[index].Values["EnrollID"]);
                int courseId = Convert.ToInt32(gvEnrolledCourses.DataKeys[index].Values["CourseID"]);
                int studentId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string logQuery = "INSERT INTO AddDropHistory (StudentID, CourseID, ActionType) VALUES (@StudentID, @CourseID, 'Drop')";
                    using (SqlCommand logCmd = new SqlCommand(logQuery, conn))
                    {
                        logCmd.Parameters.AddWithValue("@StudentID", studentId);
                        logCmd.Parameters.AddWithValue("@CourseID", courseId);
                        logCmd.ExecuteNonQuery();
                    }

                    string delQuery = "DELETE FROM Enrollments WHERE EnrollID = @EnrollID";
                    using (SqlCommand delCmd = new SqlCommand(delQuery, conn))
                    {
                        delCmd.Parameters.AddWithValue("@EnrollID", enrollId);
                        delCmd.ExecuteNonQuery();
                        CreateFinancialAdjustment(studentId, courseId, "Drop");
                    }
                }

                lblMessage.Text = "Course successfully dropped.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                LoadEnrolledCourses();
            }
        }

        private void LoadAvailableCourses()
        {
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
        private void CreateFinancialAdjustment(int studentId, int courseId, string actionType)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    decimal courseCost = 0;
                    string costQuery = "SELECT ISNULL(Cost, 0) FROM Courses WHERE CourseID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(costQuery, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        courseCost = Convert.ToDecimal(cmd.ExecuteScalar());
                    }

                    decimal adjustmentAmount = (actionType == "Add") ? -courseCost : courseCost;

                    decimal newBalance = 0;
                    string updateBalanceSql = @"
                UPDATE Users 
                SET CurrentBalance = ISNULL(CurrentBalance, 0) + @Adj 
                OUTPUT inserted.CurrentBalance
                WHERE UserID = @StudentID";

                    using (SqlCommand cmdBal = new SqlCommand(updateBalanceSql, conn, transaction))
                    {
                        cmdBal.Parameters.AddWithValue("@Adj", adjustmentAmount);
                        cmdBal.Parameters.AddWithValue("@StudentID", studentId);
                        newBalance = Convert.ToDecimal(cmdBal.ExecuteScalar());
                    }
                    object latestInvID = GetLatestInvoiceID(studentId, conn, transaction);

                    string noteQuery = @"INSERT INTO AdjustmentNotes (InvoiceID, Amount, Reason, AdjustedDate) 
                                 VALUES (@InvID, @Amt, @Reason, GETDATE())";
                    using (SqlCommand cmdNote = new SqlCommand(noteQuery, conn, transaction))
                    {
                        cmdNote.Parameters.AddWithValue("@InvID", latestInvID);
                        cmdNote.Parameters.AddWithValue("@Amt", adjustmentAmount);
                        cmdNote.Parameters.AddWithValue("@Reason", actionType + " Course: " + courseId);
                        cmdNote.ExecuteNonQuery();
                    }

                    if (newBalance < 0)
                    {
                        decimal amountToInvoice = Math.Abs(newBalance);

                        string createInvoiceSql = @"
                    INSERT INTO Invoices (StudentID, TotalAmount, Status, CreatedAt) 
                    VALUES (@sid, @amt, 'Unpaid', GETDATE())";

                        using (SqlCommand cmdInv = new SqlCommand(createInvoiceSql, conn, transaction))
                        {
                            cmdInv.Parameters.AddWithValue("@sid", studentId);
                            cmdInv.Parameters.AddWithValue("@amt", amountToInvoice);
                            cmdInv.ExecuteNonQuery();
                        }

                        string resetBalanceSql = "UPDATE Users SET CurrentBalance = 0 WHERE UserID = @sid";
                        using (SqlCommand cmdReset = new SqlCommand(resetBalanceSql, conn, transaction))
                        {
                            cmdReset.Parameters.AddWithValue("@sid", studentId);
                            cmdReset.ExecuteNonQuery();
                        }
                    }

                    transaction.Commit();
                }
                catch (Exception)
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }
        private object GetLatestInvoiceID(int studentId, SqlConnection conn, SqlTransaction trans)
        {
            string sql = "SELECT TOP 1 InvoiceID FROM Invoices WHERE StudentID = @sid ORDER BY CreatedAt DESC";
            using (SqlCommand cmd = new SqlCommand(sql, conn, trans))
            {
                cmd.Parameters.AddWithValue("@sid", studentId);
                object res = cmd.ExecuteScalar();
                return res ?? DBNull.Value;
            }
        }
        protected void btnAddSelected_Click(object sender, EventArgs e)
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

                creditLimit = (userSem % 2 == 0) ? 10 : 20;

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
                    lblMessage.Text = $"Failed! Semester {userSem} limit is {creditLimit} credits.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                int enrolledCount = 0;
                if (newlySelectedCredits > 0)
                {
                    foreach (GridViewRow row in gvAvailableCourses.Rows)
                    {
                        CheckBox chk = (CheckBox)row.FindControl("chkSelect");
                        if (chk != null && chk.Checked)
                        {
                            int courseId = Convert.ToInt32(gvAvailableCourses.DataKeys[row.RowIndex].Value);

                            string enrollQuery = "INSERT INTO Enrollments (StudentID, CourseID, Status) VALUES (@StudentID, @CourseID, 'Active')";
                            using (SqlCommand cmd = new SqlCommand(enrollQuery, conn))
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
                                CreateFinancialAdjustment(studentId, courseId, "Add");
                            }
                            enrolledCount++;
                        }
                    }
                }

                if (enrolledCount > 0)
                {
                    lblMessage.Text = "Courses successfully added!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    LoadEnrolledCourses();
                    LoadAvailableCourses();
                }
                else
                {
                    lblMessage.Text = "Please select at least one course.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }
    }
}
