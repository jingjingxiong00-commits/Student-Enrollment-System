<%@ Page Title="View Receipt" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewReceipt.aspx.cs" Inherits="Project.ViewReceipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* 基础容器：确保网页显示时居中且有边框 */
        .receipt-container {
            max-width: 800px;
            margin: 20px auto;
            background: #fff;
            padding: 40px;
            border: 2px solid #333; /* 显眼的黑边框 */
            border-radius: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        /* 打印布局强力修复 */
        @media print {
            nav, .navbar, footer, .no-print, .btn { display: none !important; }
            body, .container, .main-content { width: 100% !important; margin: 0 !important; padding: 0 !important; }
            
            .receipt-container {
                border: 2px solid #000 !important;
                width: 100% !important;
                max-width: none !important;
                margin: 0 !important;
                box-shadow: none !important;
                padding: 20px !important;
            }

            .flex-row-print { display: flex !important; justify-content: space-between !important; }
            .text-right-print { text-align: right !important; }
            .table-bordered th, .table-bordered td { border: 1px solid #000 !important; }
        }

        /* 网页 Flex 布局 */
        .flex-row-custom { display: flex; justify-content: space-between; margin-bottom: 20px; }
        .text-right-custom { text-align: right; }
    </style>

    <div class="container mt-5">
        <div id="printableArea" class="receipt-container">
            
            <div class="text-center" style="border-bottom: 3px solid #333; padding-bottom: 15px; margin-bottom: 25px;">
                <h1 style="margin: 0; font-weight: bold; letter-spacing: 2px;">OFFICIAL RECEIPT</h1>
                <p style="text-transform: uppercase; color: #666; margin-top: 5px;">Student Enrollment System</p>
            </div>

            <div class="flex-row-custom flex-row-print">
                <div style="flex: 1;">
                    <h4 style="border-bottom: 1px solid #eee; display: inline-block;">Student Details</h4>
                    <p style="margin-top: 10px;">
                        <strong>Name:</strong> <asp:Label ID="lblStudentName" runat="server"></asp:Label><br />
                        <strong>Student ID:</strong> <asp:Label ID="lblStudentID" runat="server"></asp:Label>
                    </p>
                </div>
                <div class="text-right-custom text-right-print" style="flex: 1;">
                    <h4 style="border-bottom: 1px solid #eee; display: inline-block;">Receipt Details</h4>
                    <p style="margin-top: 10px;">
                        <strong>Receipt #:</strong> <asp:Label ID="lblReceiptNum" runat="server" Font-Bold="true" ForeColor="Blue"></asp:Label><br />
                        <strong>Date:</strong> <asp:Label ID="lblDate" runat="server"></asp:Label>
                    </p>
                </div>
            </div>

            <div class="table-responsive" style="margin-top: 30px;">
                <table class="table table-bordered" style="width: 100%; border: 1px solid #333;">
                    <thead style="background-color: #eee;">
                        <tr>
                            <th style="padding: 12px; border: 1px solid #333;">Description</th>
                            <th style="padding: 12px; border: 1px solid #333; width: 180px;" class="text-right-custom text-right-print">Amount (RM)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="padding: 12px; border: 1px solid #333;">Tuition Fee Payment (Invoice #<asp:Label ID="lblInvoiceID" runat="server"></asp:Label>)</td>
                            <td style="padding: 12px; border: 1px solid #333;" class="text-right-custom text-right-print">
                                <asp:Label ID="lblAmount" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div style="margin-top: 20px;">
                <p style="font-weight: bold; color: #555;">Adjustment Breakdowns:</p>
                <asp:Repeater ID="rptAdjustments" runat="server">
                    <ItemTemplate>
                        <div style="display: flex; justify-content: space-between; padding: 5px 0; border-bottom: 1px dashed #ddd;">
                            <span><%# Eval("Reason") %></span>
                            <span>RM <%# Eval("Amount", "{0:N2}") %></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="text-right-custom text-right-print" style="margin-top: 40px; border-top: 2px solid #333; padding-top: 15px;">
                <p style="margin: 0;">Original Total: RM <asp:Label ID="lblOrg" runat="server"></asp:Label></p>
                <p style="margin: 0;">Total Adjustments: RM <asp:Label ID="lblAdj" runat="server"></asp:Label></p>
                <h2 style="margin-top: 10px; font-weight: bold;">TOTAL PAID: RM <asp:Label ID="lblPaid" runat="server"></asp:Label></h2>
            </div>

            <div style="margin-top: 50px; padding-top: 10px; border-top: 1px solid #eee; font-size: 12px;">
                <p><strong>Payment Method:</strong> <asp:Label ID="lblMethod" runat="server"></asp:Label></p>
                <p style="font-style: italic; color: #888;">* This is a computer-generated receipt and requires no signature.</p>
            </div>

        </div> <div class="text-center mt-5 no-print" style="padding-bottom: 50px;">
            <button type="button" class="btn btn-primary btn-lg" style="padding: 10px 40px;" onclick="window.print();">
                <i class="glyphicon glyphicon-print"></i> Print Receipt
            </button>
            <a href="Payment.aspx" class="btn btn-default btn-lg" style="margin-left: 10px;">Back to Portal</a>
        </div>
    </div>
</asp:Content>