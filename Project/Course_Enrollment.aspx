<%@ Page Title="Course Enrollment" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Course_Enrollment.aspx.cs" Inherits="Project.CourseEnrollment" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li class="active"><a href="Course_Enrollment.aspx">Course Enrollment</a></li>
    <li><a href="Course_AddDrop.aspx">Add/Drop Course</a></li>
    <li><a href="AddDrop_History.aspx">Add/Drop Histroy</a></li>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="max-width: 900px; margin-top: 30px;">
        
        <asp:Label ID="lblMessage" runat="server" Style="font-size: 16px; font-weight: bold; margin-bottom: 15px; display: block;"></asp:Label>

        <asp:PlaceHolder ID="phEnrollmentContent" runat="server">
            <h2 style="margin-bottom: 25px;">Course Enrollment</h2>

            <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px; border: 1px solid #ddd;">
                <h4 style="margin-top: 0; color: #0d6efd;">My Enrolled Courses</h4>
                <asp:GridView ID="gvEnrolledCourses" runat="server" AutoGenerateColumns="False"
                    Width="100%" CellPadding="8" GridLines="Horizontal" Style="border-collapse: collapse; background-color: white;">
                    <HeaderStyle BackColor="#e9ecef" Font-Bold="True" HorizontalAlign="Left" />
                    <Columns>
                        <asp:BoundField DataField="CourseCode" HeaderText="Code" ItemStyle-Width="20%" />
                        <asp:BoundField DataField="CourseName" HeaderText="Course Name" ItemStyle-Width="55%" />
                        <asp:BoundField DataField="Credits" HeaderText="Credits" ItemStyle-Width="25%" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 10px; color: #666;">
                            You are not currently enrolled in any courses.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <h4 style="margin-bottom: 15px;">Available Courses for Enrollment</h4>
            <asp:GridView ID="gvAvailableCourses" runat="server" AutoGenerateColumns="False" DataKeyNames="CourseID"
                Width="100%" CellPadding="10" GridLines="Horizontal" Style="border-collapse: collapse; margin-bottom: 20px;">
                <HeaderStyle BackColor="#f8f9fa" Font-Bold="True" HorizontalAlign="Left" />
                <Columns>
                    <asp:TemplateField HeaderText="Select" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkSelect" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CourseCode" HeaderText="Code" ItemStyle-Width="20%" />
                    <asp:BoundField DataField="CourseName" HeaderText="Course Name" ItemStyle-Width="55%" />
                    <asp:BoundField DataField="Credits" HeaderText="Credits" ItemStyle-Width="25%" />
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding: 15px; background-color: #e9ecef; border-radius: 5px; color: #666;">
                        No additional courses available to enroll in.
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>

            <asp:Button ID="btnEnroll" runat="server" Text="Submit Enrollment" OnClick="btnEnroll_Click"
                Style="background-color: #198754; color: white; border: none; padding: 10px 20px; font-size: 16px; border-radius: 5px; cursor: pointer;" />

        </asp:PlaceHolder>
    </div>
</asp:Content>
