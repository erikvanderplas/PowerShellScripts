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