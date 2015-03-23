###############################################################################
#
#	Created by:		Erik van der Plas
#	Company: 		Sogeti Netherlands B.V.
#       
# 	Created on:		February 23, 2015
#
#	Version:		1.0
#
#	Office 365 Connect Exchange Online
#
###############################################################################


# Connect to Exchange Online
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session