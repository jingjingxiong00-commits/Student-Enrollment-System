using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Project
{
    public partial class EvaluationForm : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EnrollmentDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
            }

            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        private void LoadCourses()
        {
            if (Session["UserID"] == null) return;
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT c.CourseID, c.CourseCode + ' - ' + c.CourseName AS CourseDisplay 
            FROM Courses c
            JOIN Enrollments e ON c.CourseID = e.CourseID
            WHERE e.StudentID = @StudentID
            AND NOT EXISTS (
                SELECT 1 FROM Evaluations ev 
                WHERE ev.CourseID = c.CourseID 
                AND ev.StudentID = @StudentID
            )";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlCourse.DataSource = dt;
                    ddlCourse.DataTextField = "CourseDisplay";
                    ddlCourse.DataValueField = "CourseID";
                    ddlCourse.DataBind();

                    ddlCourse.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Course --", ""));
                }
            }
        }

        protected void btnSubmitEvaluation_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (ddlCourse.SelectedIndex == 0 || string.IsNullOrEmpty(ddlRating.SelectedValue) || txtComments.Text.Trim() == "")
            {
                lblEvaluationResult.Text = "Please fill in all fields.";
                lblEvaluationResult.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int studentId = Convert.ToInt32(Session["UserID"]);
            int courseId = Convert.ToInt32(ddlCourse.SelectedValue);
            int rating = Convert.ToInt32(ddlRating.SelectedValue);
            string comments = txtComments.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Evaluations (StudentID, CourseID, Rating, Comments) VALUES (@StudentID, @CourseID, @Rating, @Comments)";
                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@StudentID", studentId);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                cmd.Parameters.AddWithValue("@Rating", rating);
                cmd.Parameters.AddWithValue("@Comments", comments);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblEvaluationResult.Text = "Evaluation submitted successfully.";
            lblEvaluationResult.ForeColor = System.Drawing.Color.Green;

            ddlCourse.SelectedIndex = 0;
            ddlRating.SelectedIndex = 0;
            txtComments.Text = "";
            LoadCourses();
        }
    }
}