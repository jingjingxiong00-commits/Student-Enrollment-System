using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace Project
{
    public partial class UpdateBankDetails : System.Web.UI.Page
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
                LoadBankData();
            }
        }
        private void LoadBankData()
        {
            txtStudentName.Text = "Attempting to load...";
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT u.FullName, b.BankName, b.AccountNo 
                       FROM Users u 
                       LEFT JOIN BankDetails b ON u.UserID = b.UserID 
                       WHERE u.UserID = @uid";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", Session["UserID"]);

                try
                {
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        object dbName = dr["FullName"];
                        if (dbName != DBNull.Value && !string.IsNullOrEmpty(dbName.ToString()))
                        {
                            txtStudentName.Text = dbName.ToString();
                        }
                        else
                        {
                            txtStudentName.Text = "Name Not Found in Users Table";
                        }

                        if (dr["BankName"] != DBNull.Value)
                        {
                            string savedBank = dr["BankName"].ToString();
                            if (ddlBankName.Items.FindByValue(savedBank) != null)
                            {
                                ddlBankName.SelectedValue = savedBank;
                            }
                        }

                        if (dr["AccountNo"] != DBNull.Value)
                        {
                            txtAccountNo.Text = dr["AccountNo"].ToString();
                        }
                    }
                    else
                    {
                        txtStudentName.Text = "System Error: User ID " + Session["UserID"] + " missing!";
                    }
                }
                catch (Exception ex)
                {
                    txtStudentName.Text = "Error: " + ex.Message;
                }
            }
        }

        protected void btnSaveBank_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }
            string accNo = txtAccountNo.Text.Trim();

            if (!Regex.IsMatch(accNo, @"^\d{7,16}$"))
            {
                lblStatus.Text = "Error: Account number must be 7-16 digits.";
                lblStatus.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (string.IsNullOrEmpty(ddlBankName.SelectedValue))
            {
                lblStatus.Text = "Please select a bank.";
                lblStatus.ForeColor = System.Drawing.Color.Red;
                return;
            }
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"IF EXISTS (SELECT 1 FROM BankDetails WHERE UserID = @uid)
                               UPDATE BankDetails SET BankName = @bn, AccountNo = @acc WHERE UserID = @uid;
                           ELSE
                               INSERT INTO BankDetails (UserID, BankName, AccountNo) VALUES (@uid, @bn, @acc);";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@bn", ddlBankName.SelectedValue);
                    cmd.Parameters.AddWithValue("@acc", txtAccountNo.Text.Trim());
                    cmd.Parameters.AddWithValue("@uid", Session["UserID"]);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblStatus.Text = "Bank details saved successfully!";
                    lblStatus.ForeColor = System.Drawing.Color.Green;

                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error: " + ex.Message;
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}
