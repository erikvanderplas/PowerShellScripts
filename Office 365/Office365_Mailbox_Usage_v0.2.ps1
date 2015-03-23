###############################################################################
#
#	Created by:		Erik van der Plas
#	Company: 		Sogeti Netherlands B.V.
#       
# 	Created on:		March 23, 2015
#
#	Version:		0.2
#
#	Office 365 mailbox usage
#
###############################################################################


###############################################################################
#
#	Required and optional parameter
#
###############################################################################

[CmdletBinding()]
Param(
	[Parameter(Mandatory=$False)]
    [ValidateRange(1,999)]
	[int]$Days
)

if (!$Days) {
    $Days = Read-Host 'Specify the number of days: '
    }

$Mailboxes = $null
$Mailbox = $null

$Mailboxes = Get-Mailbox -ResultSize Unlimited

ForEach ($Mailbox in $Mailboxes) {
	
	$MailboxStats = Get-MailboxStatistics $Mailbox.Identity

	If (!$MailboxStats.LastLogonTime) {
	#Write-Host "$Mailbox.Name did not used the mailbox" }
	}
	Else {

	$LastLogon = $MailboxStats.LastLogonTime -gt (get-date).adddays(-$Days)
	If ($lastLogon -eq $True) {
	Write-Host $Mailbox.Alias "has logged on past $Days days"
	}

	Else {}

	}

}