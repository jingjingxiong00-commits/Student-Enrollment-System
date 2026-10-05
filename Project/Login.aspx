<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Project.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="max-width: 500px; 
                margin: 50px auto; 
                padding: 30px; 
                border: 1px solid #ddd; 
                border-radius: 10px; 
                background-color: #ffffff; 
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
        
        <h2 style="margin-bottom: 25px; text-align: center;">User Login</h2>

        <div style="margin-bottom: 18px;">
            <asp:Label ID="lblUsername" runat="server" Text="User ID:" 
                Style="font-weight: bold; display: block; margin-bottom: 8px;"></asp:Label>
            <asp:TextBox ID="txtUsername" runat="server" Width="100%" 
                Style="padding: 10px; font-size: 16px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;"></asp:TextBox>
        </div>

        <div style="margin-bottom: 18px;">
            <asp:Label ID="lblPassword" runat="server" Text="Password:" 
                Style="font-weight: bold; display: block; margin-bottom: 8px;"></asp:Label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="100%" 
                Style="padding: 10px; font-size: 16px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;"></asp:TextBox>
        </div>

        <div style="margin-bottom: 18px;">
            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click"
                Style="background-color: #0d6efd; color: white; border: none; padding: 12px 20px; font-size: 16px; border-radius: 5px; width: 100%; cursor: pointer;" />
        </div>

        <div style="text-align: center;">
            <asp:Label ID="lblResult" runat="server" Style="font-size: 16px; font-weight: 500; color: #d9534f;"></asp:Label>
        </div>
    </div>
</asp:Content>