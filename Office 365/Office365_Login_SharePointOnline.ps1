Write-host
Write-host "Enter you're Office 365 adminstrator credentials" -ForegroundColor Black -BackgroundColor Yellow
Write-host

$Cred = Get-Credential

$Username = $Cred.UserName

$Domain = $Username.split('@.')
$SharePoint = $Domain[1]

Import-Module Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url https://$SharePoint-admin.sharepoint.com -credential $Cred -ErrorAction Stop

cls

Write-host
Write-host
Write-host "It is possible to use PowerShell for Office 365 SharePoint Online" -ForegroundColor Black -BackgroundColor Yellow
