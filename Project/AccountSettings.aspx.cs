using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace Project
{
    public partial class AccountSettings : System.Web.UI.Page
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
                LoadUserProfile();
            }


        }
        private void LoadUserProfile()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT u.FullName, p.Address, p.Phone, p.DOB FROM Users u " +
                             "LEFT JOIN StudentProfiles p ON u.UserID = p.UserID WHERE u.UserID = @uid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", Session["UserID"]);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtFullName.Text = dr["FullName"].ToString();
                    txtAddress.Text = dr["Address"].ToString();
                    txtPhone.Text = dr["Phone"].ToString();

                    if (dr["DOB"] != DBNull.Value)
                    {
                        DateTime dob = Convert.ToDateTime(dr["DOB"]);
                        txtDOB.Text = dob.ToString("yyyy-MM-dd");
                    }
                }
            }
        }

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            lblProfileMsg.Text = "";
            lblPhoneError.Text = "";
            lblDbError.Text = "";
            string phoneInput = txtPhone.Text.Trim();

            if (!Regex.IsMatch(phoneInput, @"^[0-9]{10,12}$"))
            {
                lblPhoneError.Text = "Error: Phone number must be 10-12 digits.";
                return;
            }
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"IF EXISTS (SELECT 1 FROM StudentProfiles WHERE UserID = @uid)
                           UPDATE StudentProfiles SET Address = @addr, Phone = @phone, DOB = @dob WHERE UserID = @uid;
                       ELSE
                           INSERT INTO StudentProfiles (UserID, Address, Phone, DOB) VALUES (@uid, @addr, @phone, @dob);";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@uid", System.Data.SqlDbType.Int).Value = Session["UserID"];
                cmd.Parameters.Add("@addr", System.Data.SqlDbType.NVarChar).Value = txtAddress.Text;
                cmd.Parameters.Add("@phone", System.Data.SqlDbType.NVarChar).Value = phoneInput;

                DateTime selectedDate;
                if (!string.IsNullOrEmpty(txtDOB.Text) && DateTime.TryParse(txtDOB.Text, out selectedDate))
                {
                    cmd.Parameters.Add("@dob", System.Data.SqlDbType.Date).Value = selectedDate;
                }
                else
                {
                    cmd.Parameters.Add("@dob", System.Data.SqlDbType.Date).Value = DBNull.Value;
                }

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    lblDbError.ForeColor = System.Drawing.Color.Green;
                    lblDbError.Text = "Profile updated successfully!";
                }
                catch (Exception)
                {
                    lblDbError.ForeColor = System.Drawing.Color.Red;
                    lblDbError.Text = "An error occurred while saving.";
                }
            }
        }

        protected void btnChangePwd_Click(object sender, EventArgs e)
        {
            lblOldPwdError.Text = "";
            lblNewPwdError.Text = "";
            lblDbError.Text = "";

            string newPwd = txtNewPwd.Text;
            var pwdRegex = new Regex(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");

            if (!pwdRegex.IsMatch(newPwd))
            {
                lblNewPwdError.Text = "Complexity requirements not met!";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string checkSql = "SELECT COUNT(1) FROM Users WHERE UserID = @uid AND Password = @old";
                SqlCommand checkCmd = new SqlCommand(checkSql, conn);
                checkCmd.Parameters.AddWithValue("@uid", Session["UserID"]);
                checkCmd.Parameters.AddWithValue("@old", txtOldPwd.Text);

                conn.Open();
                int count = (int)checkCmd.ExecuteScalar();

                if (count > 0)
                {
                    string updateSql = "UPDATE Users SET Password = @new WHERE UserID = @uid";
                    SqlCommand updateCmd = new SqlCommand(updateSql, conn);
                    updateCmd.Parameters.AddWithValue("@new", txtNewPwd.Text);
                    updateCmd.Parameters.AddWithValue("@uid", Session["UserID"]);
                    updateCmd.ExecuteNonQuery();

                    lblDbError.ForeColor = System.Drawing.Color.Green;
                    lblDbError.Text = "Success: Password updated!";
                }
                else
                {
                    lblOldPwdError.Text = "Current password is incorrect!";
                    txtOldPwd.Focus();
                }
            }
        }
        protected void btnGoToBank_Click(object sender, EventArgs e)
        {

            Response.Redirect("UpdateBankDetails.aspx");
        }

    }
}