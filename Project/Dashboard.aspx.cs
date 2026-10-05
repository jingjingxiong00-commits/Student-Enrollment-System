using System;

namespace Project
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["FullName"] != null)
                {
                    lblStudentName.Text = Session["FullName"].ToString();
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

    }
}