<%@ Page Title="Payment History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PaymentHistory.aspx.cs" Inherits="Project.PaymentHistory" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li><a href="Payment.aspx">Payment</a></li>
    <li class="active"><a href="PaymentHistory.aspx">History</a></li>
    <li><a href="StudentStatement.aspx">Statement</a></li>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .invoice-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .text-danger-bold { font-weight: bold; color: #dc3545; }
        .text-success-bold { font-weight: bold; color: #28a745; }
    </style>

    <div class="invoice-card">
        <h3>Payment History</h3>
        <asp:Label ID="lblNoHistory" runat="server" Text="No payment history found." CssClass="text-muted" Visible="false"></asp:Label>
        <asp:GridView ID="gvPaymentHistory" runat="server" AutoGenerateColumns="False" CssClass="table table-striped">
            <Columns>
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:HyperLink ID="hlViewReceipt" runat="server"
                            NavigateUrl='<%# "ViewReceipt.aspx?ID=" + Eval("PaymentID") %>'
                            Text="View Receipt" CssClass="btn btn-sm btn-info">
                        </asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ReceiptNumber" HeaderText="Receipt #" />
                <asp:BoundField DataField="PaymentDate" HeaderText="Date" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                <asp:BoundField DataField="AmountPaid" HeaderText="Amount (RM)" DataFormatString="{0:N2}" />
                <asp:BoundField DataField="PaymentMethod" HeaderText="Method" />
                <asp:BoundField DataField="InvoiceID" HeaderText="Invoice #" />
            </Columns>
        </asp:GridView>

        <div style="margin-top: 60px; border-top: 2px solid #f8f9fa; padding-top: 20px;">
            <h3 class="text-secondary">Adjustments & Notes</h3>
            <asp:Label ID="lblNoAdjustments" runat="server" Text="No adjustment records found." CssClass="text-muted" Visible="false"></asp:Label>

            <asp:GridView ID="gvAdjustments" runat="server" AutoGenerateColumns="False" CssClass="table table-hover border mt-3">
                <Columns>
                    <asp:BoundField DataField="AdjustedDate" HeaderText="Date" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="InvoiceID" HeaderText="Invoice #" />
                    <asp:BoundField DataField="Reason" HeaderText="Reason / Remarks" />
                    <asp:TemplateField HeaderText="Amount (RM)">
                        <ItemTemplate>
                            <span class='<%# Convert.ToDecimal(Eval("Amount")) < 0 ? "text-danger-bold" : "text-success-bold" %>'>
                                <%# Eval("Amount", "{0:N2}") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>