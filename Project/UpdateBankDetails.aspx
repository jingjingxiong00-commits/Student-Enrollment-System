<%@ Page Title="Bank Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UpdateBankDetails.aspx.cs" Inherits="Project.UpdateBankDetails" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li><a href="AccountSettings.aspx">Account Settings</a></li>
    <li class="active"><a href="UpdateBankDetails.aspx">Bank Details</a></li>
    <li><a href="RegistrationSummary.aspx">Registration Summary</a></li>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var oriBank, oriAcc;

        window.onload = function () {
            var ddlBank = document.getElementById('<%= ddlBankName.ClientID %>');
            if (ddlBank) {
                oriBank = ddlBank.options[ddlBank.selectedIndex].value;
            }
            var txtAcc = document.getElementById('<%= txtAccountNo.ClientID %>');
            if (txtAcc) {
                oriAcc = txtAcc.value;
            }
        };

        function checkBankChanges() {
            var ddlBank = document.getElementById('<%= ddlBankName.ClientID %>');
            var txtAcc = document.getElementById('<%= txtAccountNo.ClientID %>');
            var lblStatus = document.getElementById('<%= lblStatus.ClientID %>');

            if (typeof (Page_ClientValidate) == 'function') {
                var isPageValid = Page_ClientValidate();
                if (!isPageValid) {
                    lblStatus.innerText = "";
                    return false;
                }
            }

            var currBank = ddlBank.options[ddlBank.selectedIndex].value;
            if (currBank === "") {
                lblStatus.style.color = "red";
                lblStatus.innerText = "Please select a valid bank.";
                return false;
            }

            var currAcc = txtAcc.value;
            if (currBank === oriBank && currAcc === oriAcc) {
                lblStatus.style.color = "orange";
                lblStatus.innerText = "No changes detected. Your bank details are already up to date.";
                return false;
            }

            lblStatus.innerText = "";
            return true;
        }
    </script>

    <h2>Bank Account Details</h2>
    <p class="text-muted">Please provide your bank information for refund purposes.</p>
    <hr />

    <div class="row">
        <div class="col-md-6">
            <div class="form-group">
                <label>Account Holder Name:</label>
                <asp:TextBox ID="txtStudentName" runat="server" CssClass="form-control"
                    BackColor="#eeeeee" ReadOnly="true" />
                <small class="text-danger" style="display: block; margin-top: 5px; font-weight: bold;">
                    * Important: The bank account must belong to the student named above.
                </small>
            </div>

            <div class="form-group" style="margin-top: 15px;">
                <label>Bank Name:</label>
                <asp:DropDownList ID="ddlBankName" runat="server" CssClass="form-control">
                    <asp:ListItem Text="-- Select Bank --" Value="" />
                    <asp:ListItem Text="Maybank" Value="Maybank" />
                    <asp:ListItem Text="CIMB Bank" Value="CIMB Bank" />
                    <asp:ListItem Text="Public Bank" Value="Public Bank" />
                    <asp:ListItem Text="RHB Bank" Value="RHB Bank" />
                    <asp:ListItem Text="Hong Leong Bank" Value="Hong Leong Bank" />
                    <asp:ListItem Text="AmBank" Value="AmBank" />
                    <asp:ListItem Text="UOB Bank" Value="UOB Bank" />
                    <asp:ListItem Text="Bank Islam" Value="Bank Islam" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvBank" runat="server" ControlToValidate="ddlBankName"
                    InitialValue="" ErrorMessage="Please select a bank" ForeColor="Red" Display="Dynamic" />
            </div>

            <div class="form-group" style="margin-top: 15px;">
                <label>Account Number:</label>
                <asp:TextBox ID="txtAccountNo" runat="server" CssClass="form-control"
                    MaxLength="16" placeholder="7 to 16 digits" />
                <asp:RequiredFieldValidator ID="rfvAcc" runat="server" ControlToValidate="txtAccountNo"
                    ErrorMessage="Account Number is required" ForeColor="Red" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revAcc" runat="server"
                    ControlToValidate="txtAccountNo"
                    ValidationExpression="^\d{7,16}$"
                    ErrorMessage="Account number must be between 7 and 16 digits."
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <div style="margin-top: 25px;">
                <asp:Button ID="btnSaveBank" runat="server" Text="Save Bank Details" CssClass="btn btn-success"
                    OnClientClick="return checkBankChanges();" OnClick="btnSaveBank_Click" />
                
                <div style="margin-top: 10px;">
                    <asp:Label ID="lblStatus" runat="server" Font-Bold="true" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>