<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Project.Dashboard" %>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <div style="padding: 15px 0; font-family: 'Segoe UI', Arial, sans-serif;">
        
        <div style="margin-bottom: 35px; border-left: 5px solid #222; padding-left: 15px;">
            <h2 style="font-weight: 300; margin-top: 0;">Welcome back, 
                <span style="color: #000; font-weight: 700;">
                    <asp:Label ID="lblStudentName" runat="server" Text="Student"></asp:Label>
                </span>!
            </h2>
            <p style="color: #666; margin-bottom: 0;">Access your academic and financial records from the portal below.</p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(450px, 1fr)); gap: 25px;">
            
            <%-- Enrollment --%>
            <div class="dashboard-card">
                <h4><i class="glyphicon glyphicon-book"></i> Enrollment</h4>
                <div class="link-group">
                    <a href="Course_Enrollment.aspx">Online Course Enrollment</a>
                    <a href="Course_AddDrop.aspx">Course Add / Drop</a>
                    <a href="AddDrop_History.aspx">Add / Drop History</a>
                </div>
            </div>

            <%-- Enquiry --%>
            <div class="dashboard-card">
                <h4><i class="glyphicon glyphicon-info-sign"></i> Enquiry & Academic</h4>
                <div class="link-group">
                    <a href="TimetableMatching.aspx">Timetable Matching</a>
                    <a href="Enquiry.aspx">Contact Us / Support</a>
                    <a href="EnquiryStatus.aspx">History</a>
                    <a href="EvaluationForm.aspx">Teaching Evaluation (SET)</a>
                </div>
            </div>

            <%-- Finance --%>
            <div class="dashboard-card">
                <h4><i class="glyphicon glyphicon-usd"></i> Finance & Payment</h4>
                <div class="link-group">
                    <a href="Payment.aspx">Make a Payment</a>
                    <a href="PaymentHistory.aspx">Payment History</a>
                    <a href="StudentStatement.aspx">Student Statement (Invoice)</a>
                </div>
            </div>

            <%-- Account --%>
            <div class="dashboard-card">
                <h4><i class="glyphicon glyphicon-user"></i> Account Management</h4>
                <div class="link-group">
                    <a href="AccountSettings.aspx">Update Profile</a>
                    <a href="UpdateBankDetails.aspx">Update Bank Details</a>
                    <a href="RegistrationSummary.aspx">Registration Summary / Timetable</a>
                </div>
            </div>

        </div>
    </div>

    <style>
        .dashboard-card {
            border: 1px solid #ddd;
            padding: 22px;
            border-radius: 8px;
            background-color: #fff;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            border-color: #000;
        }

        .dashboard-card h4 {
            color: #000;
            font-weight: 600;
            font-size: 1.25em;
            margin: 0 0 15px 0;
            border-bottom: 2px solid #f5f5f5;
            padding-bottom: 12px;
            display: flex;
            align-items: center;
        }

        .dashboard-card h4 i { 
            margin-right: 12px; 
            color: #333; 
        }
        
        .link-group a {
            display: block;
            padding: 10px 0;
            color: #444;
            text-decoration: none;
            border-bottom: 1px dashed #eee;
            font-size: 0.95em;
        }

        .link-group a:last-child { 
            border-bottom: none; 
        }
        .link-group a:hover {
            color: #000;
            padding-left: 8px;
            transition: all 0.2s ease;
            font-weight: 600;
        }

        .link-group a::before {
            content: "→";
            margin-right: 10px;
            color: #000;
            font-weight: bold;
        }

        .highlight { 
            font-weight: bold; 
            color: #000 !important; 
            text-decoration: underline !important; 
        }
    </style>
</asp:Content>