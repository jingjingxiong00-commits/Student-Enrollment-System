<%@ Page Title="Enquiry Status" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EnquiryStatus.aspx.cs" Inherits="Project.EnquiryStatus" %>
<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li><a href="TimetableMatching.aspx">Timetable</a></li>
    <li><a href="Enquiry.aspx">Contact Us</a></li>
    <li class="active"><a href="EnquiryStatus.aspx">History</a></li>
    <li><a href="EvaluationForm.aspx">Evaluation</a></li>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="max-width:1000px; margin-top:30px;">
        <h2 style="margin-bottom:25px;">Enquiry Status</h2>

        <asp:GridView ID="gvEnquiries" runat="server" AutoGenerateColumns="False" Width="100%"
            BorderWidth="1px" CellPadding="10" GridLines="Both"
            HeaderStyle-BackColor="#212529"
            HeaderStyle-ForeColor="White"
            HeaderStyle-Font-Bold="true">
            <Columns>
                <asp:BoundField DataField="EnquiryID" HeaderText="Enquiry ID" />
                <asp:BoundField DataField="Subject" HeaderText="Subject" />
                <asp:BoundField DataField="Message" HeaderText="Message" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:BoundField DataField="AdminReply" HeaderText="Admin Reply" />
            </Columns>
        </asp:GridView>

        <br />
        <asp:Label ID="lblStatusResult" runat="server" Style="font-size:18px; font-weight:500;"></asp:Label>
    </div>
</asp:Content>