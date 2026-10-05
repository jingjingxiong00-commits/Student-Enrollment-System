<%@ Page Title="Enquiry" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Enquiry.aspx.cs" Inherits="Project.Enquiry" %>
<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li><a href="TimetableMatching.aspx">Timetable</a></li>
    <li class="active"><a href="Enquiry.aspx">Contact Us</a></li>
    <li><a href="EnquiryStatus.aspx">History</a></li>
    <li><a href="EvaluationForm.aspx">Evaluation</a></li>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="max-width:700px; margin-top:30px;">
        <h2 style="margin-bottom:25px;">Contact Us / Enquiry</h2>

        <div style="margin-bottom:18px;">
            <asp:Label ID="lblSubject" runat="server" Text="Subject:" 
                Style="font-weight:bold; display:block; margin-bottom:8px;"></asp:Label>
            <asp:TextBox ID="txtSubject" runat="server" Width="100%" 
                Style="padding:10px; font-size:16px;"></asp:TextBox>
        </div>

        <div style="margin-bottom:18px;">
            <asp:Label ID="lblMessage" runat="server" Text="Message:" 
                Style="font-weight:bold; display:block; margin-bottom:8px;"></asp:Label>
            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="6" Width="100%" 
                Style="padding:10px; font-size:16px;"></asp:TextBox>
        </div>

        <div style="margin-bottom:18px;">
            <asp:Button ID="btnSubmit" runat="server" Text="Submit Enquiry" OnClick="btnSubmit_Click"
                Style="background-color:#0d6efd; color:white; border:none; padding:10px 20px; font-size:16px; border-radius:5px;" />
        </div>

        <asp:Label ID="lblResult" runat="server" Style="font-size:18px; font-weight:500;"></asp:Label>
    </div>
</asp:Content>