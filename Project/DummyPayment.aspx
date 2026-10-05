<%@ Page Title="Secure Verification" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="display: flex; justify-content: center; align-items: center; min-height: 80vh; padding: 20px;">
        <div id="divProcessing" style="width: 100%; max-width: 450px;">
            
            <div style="text-align: center;">
                <div class="spinner-border text-primary mb-3" style="width: 3rem; height: 3rem;"></div>
                <h2 class="mt-2">Secure Verification</h2>
                <p class="text-muted">A 6-digit TAC code has been sent to your registered device.</p>
            </div>
            
            <div class="card shadow-sm" style="border: 1px solid #eee; border-radius: 15px; padding: 30px 25px; margin: 0 auto; width: 100%;">                
                <label class="form-label text-muted fw-bold">Please enter TAC to authorize payment:</label>                
                <input type="text" id="txtTac" maxlength="6" class="form-control form-control-lg text-center"
                       placeholder="000000" style="letter-spacing: 8px; font-weight: bold; font-size: 24px;" />
                
                <button type="button" class="btn btn-primary btn-lg w-100 mt-4" onclick="handleVerify()">Confirm & Pay</button>
                
                <p id="pError" class="text-danger mt-3" style="display:none; font-weight: 500;"></p>
                <div class="mt-2 text-muted small">
                    Remaining attempts: <span id="spanAttempts" class="badge bg-secondary">3</span>
                </div>
            </div>
        </div>

        <div id="divSuccess" style="display:none;">
            <div class="text-success mb-3" style="font-size: 60px;">✔</div>
            <h2 class="text-success">Payment Authorized!</h2>
            <p>Transaction ID: <strong id="dispTxn">#TXN-<%= DateTime.Now.Ticks.ToString().Substring(10) %></strong></p>
            <p class="text-muted">Redirecting you back in <span id="spanTimer" class="fw-bold">3</span> seconds...</p>
        </div>
    </div>

    <script>
        var attempts = 3;

        function handleVerify() {
            var tac = document.getElementById("txtTac").value;
            var error = document.getElementById("pError");
            var span = document.getElementById("spanAttempts");

            if (tac === "123456") {
                document.getElementById("divProcessing").style.display = "none";
                document.getElementById("divSuccess").style.display = "block";

                var countdown = 3;
                var timer = setInterval(function () {
                    countdown--;
                    document.getElementById("spanTimer").innerText = countdown;
                    if (countdown <= 0) {
                        clearInterval(timer);
                        const p = new URLSearchParams(window.location.search);
                        window.location.href = "Payment.aspx?status=success&InvID=" + p.get('InvID') + "&Method=" + p.get('Method') + "&Amt=" + p.get('Amt');
                    }
                }, 1000);
            } else {
                attempts--;
                span.innerText = attempts;
                error.innerText = "Invalid TAC code! Please try again.";
                error.style.display = "block";
                document.getElementById("txtTac").value = "";
                document.getElementById("txtTac").focus();

                if (attempts <= 0) {
                    alert("Security limit reached. Redirecting back to Payment Portal.");
                    window.location.href = "Payment.aspx?status=fail";
                }
            }
        }
    </script>
</asp:Content>