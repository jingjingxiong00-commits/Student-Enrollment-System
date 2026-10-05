<%@ Page Title="Registration Summary" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegistrationSummary.aspx.cs" Inherits="Project.RegistrationSummary" %>

<asp:Content ID="ContentNav" ContentPlaceHolderID="NavContent" runat="server">
    <li><a href="AccountSettings.aspx">Account Settings</a></li>
    <li><a href="UpdateBankDetails.aspx">Bank Details</a></li>
    <li class="active"><a href="RegistrationSummary.aspx">Registration Summary</a></li>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Weekly Class Schedule</h2>
    <hr />

    <div class="table-responsive">
        <table class="table table-bordered timetable-grid" style="border: 2px solid #000;">
            <thead>
                <tr style="background-color: #333; color: white;">
                    <th>Time</th>
                    <th>Monday</th>
                    <th>Tuesday</th>
                    <th>Wednesday</th>
                    <th>Thursday</th>
                    <th>Friday</th>
                    <th>Saturday</th>
                    <th>Sunday</th>
                </tr>
            </thead>
            <tbody>
                <asp:Literal ID="ltlTimetable" runat="server"></asp:Literal>
            </tbody>
        </table>
    </div>

    <style>
        .timetable-grid { 
            table-layout: fixed; 
            width: 100%; 
            border-collapse: collapse; 
            color: #000; 
        }
        .timetable-grid th, .timetable-grid td { 
            border: 1px solid #000 !important;
            text-align: center; 
            vertical-align: middle; 
            padding: 10px 5px;
        }
        .timetable-grid th:first-child, .timetable-grid td:first-child { 
            width: 80px; 
        }
        @media print {
            .timetable-grid th { background-color: #333 !important; color: #fff !important; -webkit-print-color-adjust: exact; }
            .timetable-grid td { -webkit-print-color-adjust: exact; }
        }
    </style>
</asp:Content>