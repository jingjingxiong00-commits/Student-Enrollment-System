<%@ Page Title="Add/Drop History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddDrop_History.aspx.cs" Inherits="Project.AddDropHistory" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li><a href="Course_Enrollment.aspx">Course Enrollment</a></li>
    <li><a href="Course_AddDrop.aspx">Add/Drop Course</a></li>
    <li class="active"><a href="AddDrop_History.aspx">Add/Drop Histroy</a></li>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="max-width:900px; margin-top:30px;">
        <h2 style="margin-bottom:25px;">My Add/Drop History</h2>

        <div style="background-color:#f8f9fa; padding:20px; border-radius:8px; border: 1px solid #ddd;">
            <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" 
                Width="100%" CellPadding="10" GridLines="Horizontal" Style="border-collapse:collapse; background-color:white;">
                <HeaderStyle BackColor="#e9ecef" Font-Bold="True" HorizontalAlign="Left" />
                <Columns>
                    <asp:BoundField DataField="LogDate" HeaderText="Date & Time" DataFormatString="{0:dd MMM yyyy, hh:mm tt}" ItemStyle-Width="25%" />
                    <asp:BoundField DataField="CourseCode" HeaderText="Code" ItemStyle-Width="15%" />
                    <asp:BoundField DataField="CourseName" HeaderText="Course Name" ItemStyle-Width="45%" />
                    
                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="15%" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <span style='<%# Eval("ActionType").ToString() == "Add" ? "color:green; font-weight:bold;" : "color:red; font-weight:bold;" %>'>
                                <%# Eval("ActionType") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding:15px; color:#666;">
                        No add/drop history found.
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>