<%@ Page Title="Evaluation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EvaluationForm.aspx.cs" Inherits="Project.EvaluationForm" %>
<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li><a href="TimetableMatching.aspx">Timetable</a></li>
    <li><a href="Enquiry.aspx">Contact Us</a></li>
    <li><a href="EnquiryStatus.aspx">History</a></li>
    <li class="active"><a href="EvaluationForm.aspx">Evaluation</a></li>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="max-width:700px; margin-top:30px;">
        <h2 style="margin-bottom:25px;">Student Evaluation of Teaching</h2>

        <div style="margin-bottom:18px;">
            <asp:Label ID="lblCourse" runat="server" Text="Course:"
                Style="font-weight:bold; display:block; margin-bottom:8px;"></asp:Label>
            <asp:DropDownList ID="ddlCourse" runat="server" Width="100%"
                Style="padding:10px; font-size:16px; height:45px;"></asp:DropDownList>
        </div>

        <div style="margin-bottom:18px;">
            <asp:Label ID="lblRating" runat="server" Text="Rating:"
                Style="font-weight:bold; display:block; margin-bottom:8px;"></asp:Label>
            <asp:DropDownList ID="ddlRating" runat="server" Width="200px"
                Style="padding:10px; font-size:16px; height:45px;">
                <asp:ListItem Text="-- Select Rating --" Value=""></asp:ListItem>
                <asp:ListItem Text="1" Value="1"></asp:ListItem>
                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                <asp:ListItem Text="3" Value="3"></asp:ListItem>
                <asp:ListItem Text="4" Value="4"></asp:ListItem>
                <asp:ListItem Text="5" Value="5"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div style="margin-bottom:18px;">
            <asp:Label ID="lblComments" runat="server" Text="Comments:"
                Style="font-weight:bold; display:block; margin-bottom:8px;"></asp:Label>
            <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" Rows="6" Width="100%"
                Style="padding:10px; font-size:16px;"></asp:TextBox>
        </div>

        <div style="margin-bottom:18px;">
            <asp:Button ID="btnSubmitEvaluation" runat="server" Text="Submit Evaluation" OnClick="btnSubmitEvaluation_Click"
                Style="background-color:#0d6efd; color:white; border:none; padding:10px 20px; font-size:16px; border-radius:5px;" />
        </div>

        <asp:Label ID="lblEvaluationResult" runat="server" Style="font-size:18px; font-weight:500;"></asp:Label>
    </div>
</asp:Content>