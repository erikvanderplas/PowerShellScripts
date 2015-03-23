

$users = get-mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited

ForEach ($User in $Users) {

	$RegionalConfig = Get-MailboxRegionalConfiguration $User.Name

	if ($RegionalConfig.Language.Name -eq "nl-NL"){
	Write-Host $User.Name+' Regional Settings are good'
	}
	Else {
	
	Set-MailboxRegionalConfiguration $User.Name -Language nl-NL -TimeZone 'W. Europe Standard Time' -DateFormat d-M-yyyy -TimeFormat HH:mm
	Set-MailboxRegionalConfiguration $User.Name -LocalizeDefaultFolderName:$true
	Write-Host $User.Name+' Regional Settings are configured'
	}

}