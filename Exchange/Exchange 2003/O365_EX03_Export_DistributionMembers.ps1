###############################################################################
#
#   Created by:		Erik van der Plas
#   Company: 		Sogeti Netherlands B.V.
#       
#   Created on:		January 13, 2015
#	Version:		0.1
#
#   Get Distribution Groups and members
#   Applicable for Exchange 2003 with Windows Server 2008 R2 Domain Controllers
#
###############################################################################

$Groups = $Null
$Group = $Null
$SearchBase = $Null

Import-Module ActiveDirectory

$SearchBase = Read-Host 'Enter the SearchBase to search
Example: "OU=Groups,DC=Contoso,DC=local"'

$Groups = Get-ADGroup -filter * -SearchBase $SearchBase
$Groups | ft SamAccountName > .\grouplist.txt

ForEach ($Group in $Groups) {

	$Members = Get-ADGroupmember $Group | select-object SamAccountName
	$GroupName = $Group.SamAccountName

	$Members > .\$GroupName.txt
}