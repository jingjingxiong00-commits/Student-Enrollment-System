<%@ Page Title="Student Statement" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentStatement.aspx.cs" Inherits="Project.StudentStatement" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li><a href="Payment.aspx">Payment</a></li>
    <li><a href="PaymentHistory.aspx">History</a></li>
    <li class="active"><a href="StudentStatement.aspx">Statement</a></li>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2 class="mb-3">Student Statement</h2>

        <div class="alert alert-info shadow-sm border-primary">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h4 class="mb-1"><strong>Current Account Balance:</strong></h4>
                    <p class="mb-0 text-muted">* Credits from Dropped courses are automatically added here.</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <span style="font-size: 28px; font-weight: bold; color: #0056b3;">
                        <asp:Label ID="lblCurrentBalance" runat="server" Text="RM 0.00"></asp:Label>
                    </span>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <asp:GridView ID="gvStatement" runat="server" CssClass="table table-bordered table-hover"
                AutoGenerateColumns="False" OnRowDataBound="gvStatement_RowDataBound">
                <HeaderStyle BackColor="#343a40" ForeColor="White" Font-Bold="true" />
                <Columns>
                    <asp:BoundField DataField="InvoiceID" HeaderText="Invoice ID" />
                    <asp:BoundField DataField="TotalAmount" HeaderText="Original (RM)" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="AdjDetails" HeaderText="Adjustments" HtmlEncode="false" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                    <asp:BoundField DataField="AmountPaid" HeaderText="Paid (RM)" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="FinalBalance" HeaderText="Final Balance (RM)" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" DataFormatString="{0:yyyy-MM-dd}" NullDisplayText="Pending" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <style>
        .table-bordered th { vertical-align: middle; text-align: center; }
        .alert-info { background-color: #e3f2fd; border-left: 5px solid #007bff; }
    </style>
</asp:Content>