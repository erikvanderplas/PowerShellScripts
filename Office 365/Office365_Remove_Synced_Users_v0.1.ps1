###############################################################################
#
#	  Created by:		Erik van der Plas
#	  Company: 		  Sogeti Netherlands B.V.
#       
# 	Created on:		January 5, 2015
#	  Version:	  	0.1
#
#	Office 365 Remove All synced users from a given domain
#
###############################################################################

[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True)]
	[string]$Domain
)

if (!$Domain) {
    $Domain = Read-Host 'From which domain all synced users must be fully removed? '
    }

Get-MsolUser -All | Where {$_.UserPrincipalName -like "*@$Domain"} | Remove-MsolUser -Force
Get-MsolUser -ReturnDeletedUsers | Where {$_.UserPrincipalName -like "*@$Domain"} | Remove-MsolUser -RemoveFromRecycleBin -Force
