<%@ Page Title="Account Settings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccountSettings.aspx.cs" Inherits="Project.AccountSettings" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li class="active"><a href="AccountSettings.aspx">Account Settings</a></li>
    <li><a href="UpdateBankDetails.aspx">Bank Details</a></li>
    <li><a href="RegistrationSummary.aspx">Registration Summary</a></li>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var oriName, oriAddr, oriPhone, oriDOB;
        window.onload = function () {
            oriName = document.getElementById('<%= txtFullName.ClientID %>').value;
            oriAddr = document.getElementById('<%= txtAddress.ClientID %>').value;
            oriPhone = document.getElementById('<%= txtPhone.ClientID %>').value;
            oriDOB = document.getElementById('<%= txtDOB.ClientID %>').value;
        };

        function checkProfileChanges() {
            var msgLabel = document.getElementById('<%= lblProfileMsg.ClientID %>');
            msgLabel.innerText = "";

            var currName = document.getElementById('<%= txtFullName.ClientID %>').value;
            var currAddr = document.getElementById('<%= txtAddress.ClientID %>').value;
            var currPhone = document.getElementById('<%= txtPhone.ClientID %>').value;
            var currDOB = document.getElementById('<%= txtDOB.ClientID %>').value;

            if (currName === oriName && currAddr === oriAddr && currPhone === oriPhone && currDOB === oriDOB) {
                msgLabel.innerText = "No changes detected in your profile details.";
                return false;
            }
            return true;
        }

        function checkPasswordFilled() {
            clearMessages();
            var oldP = document.getElementById('<%= txtOldPwd.ClientID %>').value;
            var newP = document.getElementById('<%= txtNewPwd.ClientID %>').value;
            var conP = document.getElementById('<%= txtConfirmPwd.ClientID %>').value;
            var isValid = true;

            if (oldP === "") {
                document.getElementById('<%= lblOldPwdError.ClientID %>').innerText = "Current password is required.";
                isValid = false;
            }

            var pwdRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
            if (newP === "") {
                document.getElementById('<%= lblNewPwdError.ClientID %>').innerText = "New password is required.";
                isValid = false;
            } else if (!pwdRegex.test(newP)) {
                document.getElementById('<%= lblNewPwdError.ClientID %>').innerText = "Invalid format.";
                isValid = false;
            }

            return isValid;
        }

        function clearMessages() {
            document.getElementById('<%= lblOldPwdError.ClientID %>').innerText = "";
            document.getElementById('<%= lblNewPwdError.ClientID %>').innerText = "";
            document.getElementById('<%= lblDbError.ClientID %>').innerText = "";
        }
        function showError(elementId, message) {
            var el = document.getElementById(elementId);
            el.innerText = message;
            el.style.display = 'block';
        }
    </script>

    <h2>Account Settings</h2>

    <asp:Label ID="lblDbError" runat="server" Font-Bold="true" Display="Dynamic" Style="margin-bottom: 20px; display: block;"></asp:Label>

    <div class="row">
        <div class="col-md-6">
            <div style="padding: 20px; border: 1px solid #eee; border-radius: 5px;">
                <h4>Update Profile</h4>
                <div class="form-group">
                    <label>Full Name:</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" ReadOnly="true" />
                </div>
                <div class="form-group">
                    <label>Date of Birth:</label>
                    <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" TextMode="Date" />
                    <asp:RequiredFieldValidator ID="rfvDOB" runat="server" ControlToValidate="txtDOB"
                        ErrorMessage="Date of Birth is required." ForeColor="Red" Display="Dynamic" />
                </div>
                <div class="form-group">
                    <label>Address:</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Phone Number:</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="12" placeholder="10-12 digits only"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone"
                        ValidationExpression="^\d{10,12}$" ErrorMessage="Invalid format" ForeColor="Red" Display="Dynamic" />
                    <asp:Label ID="lblPhoneError" runat="server" ForeColor="Red" Font-Bold="true" Display="Dynamic"></asp:Label>
                </div>

                <asp:Label ID="lblProfileMsg" runat="server" ForeColor="Red" Font-Bold="true" Display="Dynamic"></asp:Label>

                <div style="margin-top: 20px;">
                    <asp:Button ID="btnUpdateProfile" runat="server" Text="Update Details" CssClass="btn btn-primary"
                        OnClientClick="return checkProfileChanges();" OnClick="btnUpdateProfile_Click" />
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div style="padding: 20px; border: 1px solid #eee; border-radius: 5px;">
                <h4>Change Password</h4>

                <div class="form-group">
                    <label>Current Password:</label>
                    <asp:TextBox ID="txtOldPwd" runat="server" TextMode="Password" CssClass="form-control" />
                    <asp:Label ID="lblOldPwdError" runat="server" ForeColor="Red" Font-Bold="true" Display="Dynamic"></asp:Label>
                </div>

                <div class="form-group">
                    <label>New Password:</label>
                    <asp:TextBox ID="txtNewPwd" runat="server" TextMode="Password" CssClass="form-control" />
                    <small class="text-danger" style="font-weight: bold; display: block; margin-bottom: 5px;">* Min 8 characters (A-Z, a-z, 0-9, @$!%*?&)
                    </small>
                    <asp:Label ID="lblNewPwdError" runat="server" ForeColor="Red" Font-Bold="true" Display="Dynamic"></asp:Label>
                </div>

                <div class="form-group">
                    <label>Confirm Password:</label>
                    <asp:TextBox ID="txtConfirmPwd" runat="server" TextMode="Password" CssClass="form-control" />
                    <asp:CompareValidator ID="cvPwd" runat="server" ControlToCompare="txtNewPwd" ControlToValidate="txtConfirmPwd"
                        ErrorMessage="Passwords do not match!" ForeColor="Red" Display="Dynamic" />
                </div>

                <div style="margin-top: 20px;">
                    <asp:Button ID="btnChangePwd" runat="server" Text="Update Password" CssClass="btn btn-warning"
                        OnClientClick="return checkPasswordFilled();" OnClick="btnChangePwd_Click" />
                </div>
            </div>
        </div>
    </div>

    <style>
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            margin-top: 10px;
        }

        .form-control {
            max-width: 100%;
            width: 100%;
        }
    </style>
</asp:Content>
