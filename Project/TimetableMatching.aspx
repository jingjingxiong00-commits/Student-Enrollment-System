<%@ Page Title="Timetable" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TimetableMatching.aspx.cs" Inherits="Project.Timetable" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li class="active"><a href="TimetableMatching.aspx">Timetable</a></li>
    <li><a href="Enquiry.aspx">Contact Us</a></li>
    <li><a href="EnquiryStatus.aspx">History</a></li>
    <li><a href="EvaluationForm.aspx">Evaluation</a></li>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="max-width:1000px; margin-top:30px;">
        <h2 style="margin-bottom:25px;">Timetable Matching</h2>

        <asp:GridView ID="gvTimetable" runat="server" AutoGenerateColumns="False" Width="100%" 
            BorderWidth="1px" CellPadding="10" GridLines="Both" HeaderStyle-BackColor="#212529" 
            HeaderStyle-ForeColor="White" HeaderStyle-Font-Bold="true">
            <Columns>
                <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="DayOfWeek" HeaderText="Day" />
                <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                <asp:BoundField DataField="EndTime" HeaderText="End Time" />
                <asp:BoundField DataField="Venue" HeaderText="Venue" />
            </Columns>
        </asp:GridView>

        <br />
        <asp:Label ID="lblTimetableResult" runat="server" Style="font-size:18px; font-weight:500;"></asp:Label>
    </div>
</asp:Content>