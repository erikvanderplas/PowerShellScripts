###############################################################################
#
#	Created by:		Erik van der Plas
#	Company: 		Sogeti Netherlands B.V.
#       
# 	Created on:		March 19, 2015
#
#	Version:		0.1
#
#	Office 365 Mailbox statistics
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
    [ValidateSet("Studenten","Medewerkers")]
	[string]$MailboxStatGroup,
	[Parameter(Mandatory=$False)]
    [ValidateSet("Once","Never","All")]
	[string]$LogonDate
)

if (!$MailboxStatGroup) {
    $MailboxStatGroup = Read-Host 'From which user group :

     1. Medewerkers
     2. Studenten

     (Type Mederwerkers or Studenten)'
    }

if (!$LogonDate) {
    $LogonDate = Read-Host 'User has logon at least:

     1. Once
     2. Never
     3. All

     (Type Once, Never, or All)'
    }

###############################################################################
#
#	Mailbox statistics for the group Medewerkers
#
###############################################################################

if ($MailboxStatGroup -eq "Medewerkers") {

$TabName = "Medewerkers Mailbox statistics"
$Table = $null
$Table = New-Object system.Data.DataTable “$TabName”

$col1 = New-Object system.Data.DataColumn MedewerkerIdentity,([string])
$col2 = New-Object system.Data.DataColumn LastLogonTime,([string])
$col3 = New-Object system.Data.DataColumn MedewerkerNaam,([string])

$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)

$Medewerkers = Get-Mailbox -ResultSize Unlimited | where {$_.CustomAttribute1 -eq "Medewerker"}

If ($LogonDate -eq "All") {
    ForEach ($Medewerker in $Medewerkers) {

	    $MedewerkerMailboxStats = Get-MailboxStatistics $Medewerker.Identity

	    $row = $table.NewRow()
	    $row.MedewerkerIdentity = $Medewerker.Identity
	    $row.LastLogonTime = $MedewerkerMailboxStats.LastLogonTime
	    $row.MedewerkerNaam = $MedewerkerMailboxStats.DisplayName

	    $table.Rows.Add($row)
    }
}


If ($LogonDate -eq "Once") {
    ForEach ($Medewerker in $Medewerkers) {

	    $MedewerkerMailboxStats = Get-MailboxStatistics $Medewerker.Identity

	    ForEach ($MedewerkerMailboxStat in $MedewerkerMailboxStats) {

	        If ($MedewerkerMailboxStat.LastLogonTime -ne $Null) {

	        $row = $table.NewRow()
	        $row.MedewerkerIdentity = $Medewerker.Identity
	        $row.LastLogonTime = $MedewerkerMailboxStat.LastLogonTime
	        $row.MedewerkerNaam = $MedewerkerMailboxStat.DisplayName

	        $table.Rows.Add($row)
            }
	    }
    }
}


If ($LogonDate -eq "Never") {
    ForEach ($Medewerker in $Medewerkers) {

	    $MedewerkerMailboxStats = Get-MailboxStatistics $Medewerker.Identity

	    ForEach ($MedewerkerMailboxStat in $MedewerkerMailboxStats) {

	        If ($MedewerkerMailboxStat.LastLogonTime -eq $Null) {

	        $row = $table.NewRow()
	        $row.MedewerkerIdentity = $Medewerker.Identity
	        $row.LastLogonTime = $MedewerkerMailboxStat.LastLogonTime
	        $row.MedewerkerNaam = $MedewerkerMailboxStat.DisplayName

	        $table.Rows.Add($row)
            }
	    }
    }
}

}

###############################################################################
#
#	Mailbox statistics for the group Studenten
#
###############################################################################

if ($MailboxStatGroup -eq "Studenten") {

$TabName = "Students Mailbox statistics"
$Table = $null
$Table = New-Object system.Data.DataTable “$TabName”

$col1 = New-Object system.Data.DataColumn StudentNummer,([string])
$col2 = New-Object system.Data.DataColumn LastLogonTime,([string])
$col3 = New-Object system.Data.DataColumn StudentNaam,([string])

$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)

$Students = Get-Mailbox -ResultSize Unlimited | where {$_.CustomAttribute1 -eq "Student"}

If ($LogonDate -eq "All") {
    ForEach ($Student in $Students) {

	    $StudentMailboxStats = Get-MailboxStatistics $Student.Identity

	    $row = $table.NewRow()
	    $row.StudentNummer = $Student.Identity
	    $row.LastLogonTime = $StudentMailboxStats.LastLogonTime
	    $row.StudentNaam = $StudentMailboxStats.DisplayName

	    $table.Rows.Add($row)
    }
}


If ($LogonDate -eq "Once") {
    ForEach ($Student in $Students) {

	    $StudentMailboxStats = Get-MailboxStatistics $Student.Identity

	    ForEach ($StudentMailboxStat in $StudentMailboxStats) {

	        If ($StudentMailboxStat.LastLogonTime -ne $Null) {

	        $row = $table.NewRow()
	        $row.StudentNummer = $Student.Identity
	        $row.LastLogonTime = $StudentMailboxStats.LastLogonTime
	        $row.StudentNaam = $StudentMailboxStats.DisplayName

	        $table.Rows.Add($row)
            }
	    }
    }
}


If ($LogonDate -eq "Never") {
    ForEach ($Student in $Students) {

	    $StudentMailboxStats = Get-MailboxStatistics $Student.Identity

	    ForEach ($StudentMailboxStat in $StudentMailboxStats) {

	        If ($StudentMailboxStat.LastLogonTime -eq $Null) {

	        $row = $table.NewRow()
	        $row.StudentNummer = $Student.Identity
	        $row.LastLogonTime = $StudentMailboxStats.LastLogonTime
	        $row.StudentNaam = $StudentMailboxStats.DisplayName

	        $table.Rows.Add($row)
            }
	    }
    }
}

}

$table | ft -AutoSize