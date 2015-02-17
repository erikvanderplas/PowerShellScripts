$folders = Get-ChildItem | ForEach-Object { $_.Name }

ForEach ($folder in $folders){

	
	$String = Get-ChildItem .\$folder -Recurse | Get-Content -Force | Select-String -Pattern '<TEXT_STRING>'

	If (!$String) {}
	else {$folder}
}