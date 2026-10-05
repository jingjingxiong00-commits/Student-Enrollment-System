<%@ Page Title="Course Add/Drop" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Course_AddDrop.aspx.cs" Inherits="Project.CourseAddDrop" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li><a href="Course_Enrollment.aspx">Course Enrollment</a></li>
    <li class="active"><a href="Course_AddDrop.aspx">Add/Drop Course</a></li>
    <li><a href="AddDrop_History.aspx">Add/Drop Histroy</a></li>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="max-width:800px; margin-top:30px;">
        <h2 style="margin-bottom:25px;">My Enrolled Courses</h2>

        <asp:Label ID="lblMessage" runat="server" Style="font-size:16px; font-weight:bold; margin-bottom:15px; display:block;"></asp:Label>

        <asp:GridView ID="gvEnrolledCourses" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="EnrollID,CourseID" OnRowCommand="gvEnrolledCourses_RowCommand"
            Width="100%" CellPadding="10" GridLines="Horizontal" Style="border-collapse:collapse; margin-bottom:20px;">
            <HeaderStyle BackColor="#f8f9fa" Font-Bold="True" HorizontalAlign="Left" />
            <Columns>
                <asp:BoundField DataField="CourseCode" HeaderText="Code" ItemStyle-Width="15%" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" ItemStyle-Width="45%" />
                <asp:BoundField DataField="Credits" HeaderText="Credits" ItemStyle-Width="10%" />
                <asp:TemplateField HeaderText="Action" ItemStyle-Width="15%" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Button ID="btnDrop" runat="server" Text="Drop" CommandName="DropCourse" 
                            CommandArgument='<%# Container.DataItemIndex %>'
                            OnClientClick="return confirm('Are you sure you want to drop this course?');"
                            Style="background-color:#dc3545; color:white; border:none; padding:8px 15px; font-size:14px; border-radius:4px; cursor:pointer;" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div style="padding:15px; background-color:#e9ecef; border-radius:5px; color:#666;">
                    You are not currently enrolled in any active courses.
                </div>
            </EmptyDataTemplate>
        </asp:GridView>

        <hr style="margin: 40px 0;" />
        <h2 style="margin-bottom:25px;">Available Courses to Add</h2>

        <asp:GridView ID="gvAvailableCourses" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="CourseID" Width="100%" CellPadding="10" GridLines="Horizontal" 
            Style="border-collapse:collapse; margin-bottom:20px;">
            <HeaderStyle BackColor="#f8f9fa" Font-Bold="True" HorizontalAlign="Left" />
            <Columns>
                <asp:TemplateField HeaderText="Select">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkSelect" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CourseCode" HeaderText="Code" ItemStyle-Width="15%" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" ItemStyle-Width="55%" />
                <asp:BoundField DataField="Credits" HeaderText="Credits" ItemStyle-Width="15%" />
            </Columns>
        </asp:GridView>

        <asp:Button ID="btnAddSelected" runat="server" Text="Add Selected Courses" 
            OnClick="btnAddSelected_Click"
            Style="background-color:#28a745; color:white; border:none; padding:10px 20px; font-size:16px; border-radius:4px; cursor:pointer;" />
    </div>
</asp:Content>