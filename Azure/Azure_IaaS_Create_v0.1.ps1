###############################################################################
#
#	Created by:		Erik van der Plas
#	Company: 		Sogeti Netherlands B.V.
#       
# 	Created on:		November 26, 2014
#
#	Version:		0.1
#
#	Create Azure IaaS machines
#
###############################################################################


###############################################################################
#
#	Required parameter for specifying the used PostNL domain
#
###############################################################################

[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True)]
	[string]$Name,

    [Parameter(Mandatory=$True)]
    [ValidateSet("A0","ExtraSmall","A1","Small","A2","Medium","A3","Large","A4","ExtraLarge","A5","A7","A8","A9","D0","D1","Standard_D1","D2","Standard_D2","D3","Standard_D3","D4","Standard_D4","D11","Standard_D11","D12","Standard_D12","D13","Standard_D13","D14","Standard_D14")]
    [string]$InstanceSize,

    [Parameter(Mandatory=$True)]
    [ValidateSet("Server2012","Server2012R2")]
    [string]$ImageName,

    [Parameter(Mandatory=$True)]
    [string]$AvailabilitySetName,

    [Parameter(Mandatory=$True)]
    [string]$SubnetNames,

    [Parameter(Mandatory=$True)]
    [string]$ServiceName,

    [Parameter(Mandatory=$False)]
    [string]$VnetName,

    [Parameter(Mandatory=$False)]
    [string]$AffinityGroup,

    [Parameter(Mandatory=$False)]
    [string]$Location,

    [Parameter(Mandatory=$False)]
    [string]$AzureSubscription,

    [Parameter(Mandatory=$True)]
    [string]$CurrentStorageAccountName
)

Write-Host "Enter your local admin credentials after press enter" -ForegroundColor Yellow

Pause

$AdminUserName = Get-Credential

if ($InstanceSize -eq "A0") {$AzurePSInstanceSize="ExtraSmall"}
if ($InstanceSize -eq "A1") {$AzurePSInstanceSize="Small"}
if ($InstanceSize -eq "A2") {$AzurePSInstanceSize="Medium"}
if ($InstanceSize -eq "A3") {$AzurePSInstanceSize="Large"}
if ($InstanceSize -eq "A4") {$AzurePSInstanceSize="ExtraLarge"}
if ($InstanceSize -eq "A5") {$AzurePSInstanceSize=$InstanceSize}
if ($InstanceSize -eq "A6") {$AzurePSInstanceSize=$InstanceSize}
if ($InstanceSize -eq "A7") {$AzurePSInstanceSize=$InstanceSize}
if ($InstanceSize -eq "A8") {$AzurePSInstanceSize=$InstanceSize}
if ($InstanceSize -eq "A9") {$AzurePSInstanceSize=$InstanceSize}
if ($InstanceSize -eq "D1") {$AzurePSInstanceSize="Standard_D1"}
if ($InstanceSize -eq "D2") {$AzurePSInstanceSize="Standard_D2"}
if ($InstanceSize -eq "D3") {$AzurePSInstanceSize="Standard_D3"}
if ($InstanceSize -eq "D4") {$AzurePSInstanceSize="Standard_D4"}
if ($InstanceSize -eq "D11") {$AzurePSInstanceSize="Standard_D11"}
if ($InstanceSize -eq "D12") {$AzurePSInstanceSize="Standard_D12"}
if ($InstanceSize -eq "D13") {$AzurePSInstanceSize="Standard_D13"}
if ($InstanceSize -eq "D14") {$AzurePSInstanceSize="Standard_D14"}

###############################################################################
#
#	The AzureSubscription and used storage account will be defined
#
###############################################################################


if (!$AzureSubscription) {
    $Subscription = Get-AzureSubscription -Current
    Set-AzureSubscription -SubscriptionName $Subscription.SubscriptionName -CurrentStorageAccountName $CurrentStorageAccountName
    }
Else { 
    Set-AzureSubscription -SubscriptionName $AzureSubscription -CurrentStorageAccountName $CurrentStorageAccountName
    }


###############################################################################
#
#	Select the required Server, at this moment only two different OSs are taken
#   into the script:
#   
#    - Windows Server 2012    Datacenter
#    - Windows Server 2012 R2 Datacenter
#
###############################################################################


if ($ImageName -eq "Server2012R2") {
$Image = Get-AzureVMImage | where-object {$_.ImageName -match "06__Windows-Server-2012-R2"} | Select-Object ImageName -Last 1 
 }

if ($ImageName -eq "Server2012") {
$Image = Get-AzureVMImage | where-object {$_.ImageName -match "Windows-Server-2012-Datacenter"} | Select-Object ImageName -Last 1
 } 


###############################################################################
#
#	Create a new Azure IaaS machine 
#
###############################################################################

$ServiceNameExists = Get-AzureVM -ServiceName $ServiceName 

if (!$ServiceNameExists)
    {

        Write-Host "The Cloud Service does not exist, this will be created." -ForegroundColor Yellow

        if (!$VnetName) {
            Write-Host 'You are creating a new Machine, the VnetName is required.' -ForegroundColor Red
            $VnetName = Read-Host 'VnetName'
            }

    if ($AffinityGroup) {
        # NEW VM with Affinity GROUP

        New-AzureVMConfig -Name $Name -InstanceSize $AzurePSInstanceSize -ImageName $Image.ImageName -AvailabilitySetName $AvailabilitySetName | 
        Add-AzureProvisioningConfig -Windows -DisableAutomaticUpdates -AdminUserName $AdminUserName.UserName -Password $AdminUserName.Password | 
        Set-AzureSubnet -SubnetNames $SubnetNames |
        New-AzureVM -ServiceName $ServiceName -VNETNAME $VnetName -AffinityGroup $AffinityGroup
        }
    if ($Location) {
        # NEW VM with Location

        if (!$VnetName) { $VnetName = Read-Host 'You are creating a new Machine, Enter the VnetName'}

        New-AzureVMConfig -Name $Name -InstanceSize $AzurePSInstanceSize -ImageName $Image.ImageName -AvailabilitySetName $AvailabilitySetName | 
        Add-AzureProvisioningConfig -Windows -DisableAutomaticUpdates -AdminUserName $AdminUserName.UserName -Password $AdminUserName.Password | 
        Set-AzureSubnet -SubnetNames $SubnetNames |
        New-AzureVM -ServiceName $ServiceName -VNETNAME $VnetName -Location $Location
        }
    }
Else
    {
        Write-Host "The Cloud Service already exist, only the VM will be created." -ForegroundColor Yellow

        # New VM to Existing with Location
        New-AzureVMConfig -Name $Name -InstanceSize $AzurePSInstanceSize -ImageName $Image.ImageName -AvailabilitySetName $AvailabilitySetName | 
        Add-AzureProvisioningConfig -Windows -DisableAutomaticUpdates -AdminUserName $AdminUserName.UserName -Password $AdminUserName.Password | 
        Set-AzureSubnet -SubnetNames $SubnetNames |
        New-AzureVM -ServiceName $ServiceName
    }

$AzureVMCreated = Get-AzureVM -ServiceName $ServiceName -Name $Name

If ($AzureVMCreated) { Write-Host "The Azure IaaS is not created" -ForegroundColor Red} 
Else { Write-Host "The Azure IaaS is created" -ForegroundColor Green}