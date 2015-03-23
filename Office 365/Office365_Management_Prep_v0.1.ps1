###############################################################################
#
#	Created by:		Erik van der Plas
#	Company: 		Sogeti Netherlands B.V.
#       
# 	Created on:		November 24, 2014
#
#	Version:		0.1
#
#	Office 365 Management Preperations
#
###############################################################################

#Windows PowerSHell 4.0, Windows 6.1
#http://www.microsoft.com/en-us/download/confirmation.aspx?id=40855&6B49FDFB-8E5B-4B07-BC31-15695C5A2143=1

###############################################################################
#
#	Required and optional parameter
#
###############################################################################


[CmdletBinding()]
Param(
	[Parameter(Mandatory=$False)]
    [ValidateSet("1","2","3","4")]
	[string]$ManagementOptions
)

if (!$ManagementOptions) {
    $ManagementOptions = Read-Host 'What Management Options do you want to install:

     1. Install all management modules
     2. Install Azure Active Directory PowerShell Module
     3. Install SharePoint Online Management Module
     4. Install Lync Online Management Module

     (choose a number)'
    }


###############################################################################
#
#	Create required folders:
#		Temp
#
###############################################################################


# Set Temp folder for script
$TempFolder = "C:\Temp"

# Create Temp folder
$TempFolderExists = Test-Path $TempFolder

    If ($TempFolderExists -eq $True) {Write-Host "Folder exists :-)" -ForegroundColor Green}
    Else {New-Item -Path $TempFolder -ItemType Directory}


###############################################################################
#
#	Install Prerequisites:
#		.NET Framework 3.5
#		Microsoft Online Service Sign-In Assistant
#
###############################################################################


# Install .NET Framework 3.5
$NetFrameInstall = Get-WindowsFeature NET-Framework-Core

    If ($NetFrameInstalled -eq $True) {}
    Else {Install-WindowsFeature NET-Framework-Core}


# Install Microsoft Online Service Sign-in Assistant 7.0
$MsolSSAInstalled = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq "Microsoft Online Services Sign-in Assistant"}

    If (!$MsolSSAInstalled) {
        Write-Host "Install Microsoft Online Service Sign-in Assistant 7.0" -ForegroundColor Yellow

        $SourceMsolSSA="http://download.microsoft.com/download/5/0/1/5017D39B-8E29-48C8-91A8-8D0E4968E6D4/en/msoidcli_64.msi"
        Invoke-WebRequest $SourceMsolSSA -OutFile $TempFolder\msoidcli_64.msi
        Start-Process "$TempFolder\msoidcli_64.msi" /qn -Wait

        # Clean Up
        Remove-Item $TempFolder\msoidcli_64.msi
    }
    Else {
        Write-Host "Microsoft Online Service Sign-in Assistant 7.0 is already installed" -ForegroundColor Green
    }


###############################################################################
#
#	Install Office 365 modules:
#		Azure Active Directory PowerShell Module
#		SharePoint Online module
#		Lync Online module
#
###############################################################################


If ($ManagementOptions -eq "1" -or $ManagementOptions -eq "2")
    {
    # Install Azure Active Directory PowerShell Module
    $AADmodInstalled = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq "Windows Azure Active Directory Module for Windows PowerShell"}

        If (!$AADmodInstalled) {
            Write-Host "Install Azure Active Directory PowerShell Module" -ForegroundColor yellow

            $SourceAADmod="http://go.microsoft.com/fwlink/p/?linkid=236297"
            Invoke-WebRequest $SourceAADmod -OutFile $TempFolder\AdministrationConfig-en.msi
            Start-Process "$TempFolder\AdministrationConfig-en.msi" /qn -Wait

            # Clean Up
            Remove-Item $TempFolder\AdministrationConfig-en.msi
        }
        Else {
            Write-Host "Azure Active Directory PowerShell Module is already installed" -ForegroundColor Green
            }
    }

If ($ManagementOptions -eq "1" -or $ManagementOptions -eq "3")
    {
    # Install SharePoint Online Module
    $SharePointOnlinemodInstalled = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq "SharePoint Online Management Shell"}

        If (!$SharePointOnlinemodInstalled) {
            Write-Host "Install SharePoint Online Module" -ForegroundColor Yellow

            $SourceSharePointOnline="http://download.microsoft.com/download/E/8/4/E84D0ADC-97A1-4ACB-B0FE-E71B07A76D56/sharepointonlinemanagementshell_English_x64.msi"
            Invoke-WebRequest $SourceSharePointOnline -OutFile $TempFolder\sharepointonlinemanagementshell_English_x64.msi
            Start-Process "$TempFolder\sharepointonlinemanagementshell_English_x64.msi" /qn -Wait

            # Clean Up
            Remove-Item $TempFolder\sharepointonlinemanagementshell_English_x64.msi
        }
        Else {
            Write-Host "SharePoint Online Module is already installed" -ForegroundColor Green
            }
    }

If ($ManagementOptions -eq "1" -or $ManagementOptions -eq "4")
    {
    # Install Lync Online Module
    $LyncOnlinemodInstalled = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq "Microsoft Lync Online, Windows PowerShell Module"}

        If (!$LyncOnlinemodInstalled) {
            Write-Host "Install Lync Online Module" -ForegroundColor Yellow

            $SourceLyncOnline="http://download.microsoft.com/download/2/0/5/2050B39B-4DA5-48E0-B768-583533B42C3B/LyncOnlinePowerShell.exe"
            Invoke-WebRequest $SourceLyncOnline -OutFile $TempFolder\LyncOnlinePowerShell.exe
            Start-Process "$TempFolder\LyncOnlinePowerShell.exe" /quiet -Wait

            # Clean Up
            Remove-Item $TempFolder\LyncOnlinePowerShell.exe
        }
        Else {
            Write-Host "Lync Online Module is already installed" -ForegroundColor Green
            }
    }


Write-Host "Office 365 Management Preperations are installed" -ForegroundColor Green

# Connect with Azure Active Directory PowerShell Module
#$UserCredential = Get-Credential
#Import-Module MsOnline
#Connect-MsolService -Credential $UserCredential

# Connect to Exchange Online
#$UserCredential = Get-Credential
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Import-PSSession $Session

#Connect to SharePoint Online
#$UserCredential = Get-Credential
#Import-Module Microsoft.Online.SharePoint.PowerShell
#Connect-SPOService -Url https://$SharePoint-admin.sharepoint.com -credential $UserCredential -ErrorAction Stop


#Connect to Lync Online
#$UserCredential = Get-Credential
#Import-Module LyncOnlineConnector
#$session = New-CsOnlineSession -Credential $UserCredential
#Import-PSSession $session