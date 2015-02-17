###############################################################################
#
#	Created by:		Erik van der Plas
#	Company: 		Sogeti Netherlands B.V.
#       
# 	Created on:		January 5, 2015
#
#	Version:		0.1
#
#	Office 365 Change regional settings
#
###############################################################################


[CmdletBinding()]
Param(
	[Parameter(Mandatory=$False)]
    [ValidateSet("English_US","English_UK","Dutch")]
	[string]$Language
)

if (!$Language) {
    $Language = Read-Host 'Enter a Language:

     - English_US for English United States
     - English_UK for English United Kingdom
     - Dutch for Dutch (Netherlands)
     '
    }


If ($Language -like 'English_US') { $Language = 1033 }
If ($Language -like 'English_UK') { $Language = 2057 }
If ($Language -like 'Dutch') { $Language = 1043 }

Get-Mailbox | Set-MailboxRegionalConfiguration -Language NL-nl -TimeZone 'W. Europe Standard Time' | Set-MailboxRegionalConfiguration -LocalizeDefaultFolderName:$true