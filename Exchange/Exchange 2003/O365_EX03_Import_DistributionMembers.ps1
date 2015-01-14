###############################################################################
#
#   Created by:		Erik van der Plas
#   Company: 		Sogeti Netherlands B.V.
#       
#   Created on:		January 13, 2015
#	Version:		0.1
#
#   Add Distribution Groups and Members through a CSV file
#   Applicable for Exchange 2007, 2010, 2013, and Online
#
###############################################################################

$CSV = Read-Host "Enter the full path of the CSV file:"

$DistroCSV = Import-Csv $CSV

ForEach ($DistroGroup in $DistroCSV) {

  New-DistributionGroup -Name $DistroGroup.DistributionGroupName -DisplayName $DistroGroup.DisplayName -Alias $DistroGroup.Alias -PrimarySmtpAddress $DistroGroup.PrimarySmtpAddress

  $DistroGroupName = $Null
  $DistroGroupName = $DistroGroup.DistributionGroupName
  $DistroMemberCSV = Import-CSV .\$DistroGroupName.csv

  ForEach ($DistroMember in $DistroMemberCSV) {
   
    Add-DistributionGroupMember -Identity $DistroGroupName -Member $DistroMember.Name

  }

}