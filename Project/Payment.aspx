<%@ Page Title="Payment" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="Project.Payment" %>

<%@ Import Namespace="System.Data" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li class="active"><a href="Payment.aspx">Payment</a></li>
    <li><a href="PaymentHistory.aspx">History</a></li>
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

        .amount-display {
            font-size: 24px;
            font-weight: bold;
            color: #28a745;
        }
    </style>

    <div>
        <h2>Payment Portal</h2>
        <asp:Label ID="lblStudentName" runat="server" CssClass="lead"></asp:Label>
    </div>

    <div class="invoice-card">
        <h3>Outstanding Invoices</h3>
        <asp:GridView ID="gvInvoices" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered"
            OnSelectedIndexChanged="gvInvoices_SelectedIndexChanged" DataKeyNames="InvoiceID">
            <Columns>
                <asp:BoundField DataField="InvoiceID" HeaderText="Invoice #" />
                <asp:BoundField DataField="CreatedAt" HeaderText="Date" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="TotalAmount" HeaderText="Amount (RM)" DataFormatString="{0:N2}" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:CommandField ShowSelectButton="True" SelectText="Pay Now" ButtonType="Button" />
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblNoInvoices" runat="server" Text="No outstanding invoices." CssClass="text-muted" Visible="false"></asp:Label>
    </div>

    <div class="invoice-card" id="paymentDetails" runat="server" visible="false">
        <h3>Payment Details</h3>
        <div class="row">
            <div class="col-md-6">
                <p><strong>Invoice Number:</strong>
                    <asp:Label ID="lblInvoiceID" runat="server"></asp:Label></p>
                <p><strong>Original Amount:</strong> RM
                    <asp:Label ID="lblOriginalAmount" runat="server"></asp:Label></p>
                <p style="color: #d9534f;"><strong>Minus Current Balance:</strong> - RM
                    <asp:Label ID="lblBalanceDeduction" runat="server" Text="0.00"></asp:Label></p>
                <hr />
                <p>
                    <strong>Final Amount to Pay:</strong>
                    <span class="amount-display">RM
                        <asp:Label ID="lblAmount" runat="server"></asp:Label></span>
                </p>
                <p><strong>Due Date:</strong>
                    <asp:Label ID="lblDueDate" runat="server"></asp:Label></p>
            </div>
            <div class="col-md-6">
                <div class="alert alert-info">
                    <strong>Current Wallet Balance:</strong> RM
                    <asp:Label ID="lblTotalUserBalance" runat="server" Font-Bold="true"></asp:Label>
                    <br />
                    <small>* Your available credit from previous Add/Drop will be applied automatically.</small>
                </div>
            </div>
        </div>

        <h4 class="mt-4">Select Payment Method</h4>
        <asp:RadioButtonList ID="rblPaymentMethod" runat="server" RepeatLayout="Flow">
            <asp:ListItem Value="Credit Card">💳 Credit Card</asp:ListItem>
            <asp:ListItem Value="Online Banking">🏦 Online Banking</asp:ListItem>
            <asp:ListItem Value="E-Wallet">📱 E-Wallet</asp:ListItem>
        </asp:RadioButtonList>

        <div id="creditCardDetails" style="display: none; margin-top: 20px;">
            <div class="row">
                <div class="col-md-6">
                    <label>Card Number:</label>
                    <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" placeholder="1234 5678 9012 3456"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label>Expiry Date:</label>
                    <asp:TextBox ID="txtExpiry" runat="server" CssClass="form-control" placeholder="MM/YY"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label>CVV:</label>
                    <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="123" TextMode="Password"></asp:TextBox>
                </div>
            </div>
        </div>

        <div id="bankingDetails" style="display: none; margin-top: 20px;" class="alert alert-light border">
            <label>Select Bank:</label>
            <asp:DropDownList ID="ddlBank" runat="server" CssClass="form-control mb-2">
                <asp:ListItem Value="">-- Select Bank --</asp:ListItem>
                <asp:ListItem>Maybank2u</asp:ListItem>
                <asp:ListItem>CIMB Clicks</asp:ListItem>
                <asp:ListItem>Public Bank</asp:ListItem>
            </asp:DropDownList>

            <label>Bank Registered Mobile Number (for TAC):</label>
            <asp:TextBox ID="txtBankPhone" runat="server" CssClass="form-control" placeholder="01XXXXXXXX"></asp:TextBox>
            <p class="small text-muted mt-1">* You will receive a TAC code on this number after logging into your bank.</p>
        </div>

        <div id="walletDetails" style="display: none; margin-top: 20px;" class="alert alert-light border">
            <label>Select E-Wallet Provider:</label>
            <asp:DropDownList ID="ddlWalletProvider" runat="server" CssClass="form-control mb-2">
                <asp:ListItem Value="TNG">Touch 'n Go eWallet</asp:ListItem>
                <asp:ListItem Value="GrabPay">GrabPay</asp:ListItem>
                <asp:ListItem Value="ShopeePay">ShopeePay</asp:ListItem>
            </asp:DropDownList>

            <label>Phone Number (Registered with E-Wallet):</label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="0123456789"></asp:TextBox>
            <p class="small text-muted mt-1">* A payment request will be sent to your mobile app.</p>
        </div>

        <asp:Button ID="btnProcessPayment" runat="server" Text="Process Payment"
            CssClass="btn btn-success btn-lg mt-3"
            OnClick="btnProceedPayment_Click"
            OnClientClick="return validatePayment();" />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary btn-lg mt-3 ms-2"
            OnClick="btnCancel_Click" />

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert alert-info mt-3"></asp:Label>
    </div>


    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            $('input[name$="rblPaymentMethod"]').change(function () {
                var val = $(this).val();
                $('#creditCardDetails, #bankingDetails, #walletDetails').hide();

                if (val === 'Credit Card') {
                    $('#creditCardDetails').show();
                } else if (val === 'Online Banking') {
                    $('#bankingDetails').show();
                } else if (val === 'E-Wallet') {
                    $('#walletDetails').show();
                }
            });
        });

        function validatePayment() {
            var selectedMethod = $('input[name$="rblPaymentMethod"]:checked').val();

            if (!selectedMethod) {
                alert('❌ Please select a payment method!');
                return false;
            }

            if (selectedMethod === 'Credit Card') {
                var card = $('input[id$="txtCardNumber"]').val().trim();
                var expiry = $('input[id$="txtExpiry"]').val().trim();
                var cvv = $('input[id$="txtCVV"]').val().trim();

                if (card === "" || expiry === "" || cvv === "") {
                    alert('❌ Please fill in ALL Credit Card details!');
                    return false;
                }

                var cleanCard = card.replace(/\s/g, '');

                if (!/^\d{16}$/.test(cleanCard)) {
                    alert('❌ Please enter a valid 16-digit Card Number!');
                    return false;
                }

                if (!/^\d{2}\/\d{2}$/.test(expiry)) {
                    alert('❌ Expiry Date must be in MM/YY format (e.g., 12/28)!');
                    return false;
                }

                var parts = expiry.split('/');
                var month = parseInt(parts[0], 10);
                var year = parseInt("20" + parts[1], 10);

                if (month < 1 || month > 12) {
                    alert('❌ Invalid Month! (01-12)');
                    return false;
                }

                var now = new Date();
                var currentYear = now.getFullYear();
                var currentMonth = now.getMonth() + 1;

                if (year < currentYear || (year === currentYear && month < currentMonth)) {
                    alert('❌ This card has already expired!');
                    return false;
                }

                if (!/^\d{3}$/.test(cvv)) {
                    alert('❌ CVV must be exactly 3 digits!');
                    return false;
                }
            }

            else if (selectedMethod === 'Online Banking') {
                var bank = $('select[id$="ddlBank"]').val();
                var bankPhone = $('input[id$="txtBankPhone"]').val().trim();

                if (!bank || bank === "") {
                    alert('❌ Please select your bank!');
                    return false;
                }

                if (!/^01\d{8,9}$/.test(bankPhone)) {
                    alert('❌ Please enter a valid Mobile Number (10-11 digits, starting with 01)!');
                    return false;
                }
            }

            else if (selectedMethod === 'E-Wallet') {
                var walletPhone = $('input[id$="txtPhone"]').val().trim();

                if (!/^01\d{8,9}$/.test(walletPhone)) {
                    alert('❌ Please enter a valid E-Wallet phone number (10-11 digits, starting with 01)!');
                    return false;
                }
            }

            return confirm("Confirm payment and proceed to secure verification?");
        }
    </script>
</asp:Content>
