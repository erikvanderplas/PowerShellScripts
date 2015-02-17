$VMconfig = Import-Csv C:\azurevm_input.csv


$ServiceNameExists = Get-AzureVM -ServiceName $ServiceName 


if ($VM.InstanceSize -eq "A0") {$VM.InstanceSize="ExtraSmall"}
if ($VM.InstanceSize -eq "A1") {$VM.InstanceSize="Small"}
if ($VM.InstanceSize -eq "A2") {$VM.InstanceSize="Medium"}
if ($VM.InstanceSize -eq "A3") {$VM.InstanceSize="Large"}
if ($VM.InstanceSize -eq "A4") {$VM.InstanceSize="ExtraLarge"}

if ($VM.InstanceSize -eq "D1") {$VM.InstanceSize="Standard_D1"}
if ($VM.InstanceSize -eq "D2") {$VM.InstanceSize="Standard_D2"}
if ($VM.InstanceSize -eq "D3") {$VM.InstanceSize="Standard_D3"}
if ($VM.InstanceSize -eq "D4") {$VM.InstanceSize="Standard_D4"}
if ($VM.InstanceSize -eq "D11") {$VM.InstanceSize="Standard_D11"}
if ($VM.InstanceSize -eq "D12") {$VM.InstanceSize="Standard_D12"}
if ($VM.InstanceSize -eq "D13") {$VM.InstanceSize="Standard_D13"}
if ($VM.InstanceSize -eq "D14") {$VM.InstanceSize="Standard_D14"}


if (!$ServiceNameExists)
    {

        Write-Host "The Cloud Service does not exist, this will be created" -ForegroundColor Yellow

    if ($AffinityGroup) {
        foreach ($VM in $VMconfig) {
            New-AzureVMConfig -Name $VM.name -InstanceSize $VM.InstanceSize -ImageName $VM.ImageName -AvailabilitySetName $VM.AvailabilitySetName | 
            Add-AzureProvisioningConfig -Windows -DisableAutomaticUpdates -AdminUserName $VM.AdminUserName -Password $VM.Password | 
            Set-AzureSubnet -SubnetNames $VM.SubnetNames | 
            New-AzureVM -ServiceName $VM.ServiceName -VNETNAME $VM.VNETNAME -AffinityGroup $VM.AffinityGroup #-Location $VM.Location
        }
    }

    if ($Location) {
        foreach ($VM in $VMconfig) {
            New-AzureVMConfig -Name $VM.name -InstanceSize $VM.InstanceSize -ImageName $VM.ImageName -AvailabilitySetName $VM.AvailabilitySetName | 
            Add-AzureProvisioningConfig -Windows -DisableAutomaticUpdates -AdminUserName $VM.AdminUserName -Password $VM.Password | 
            Set-AzureSubnet -SubnetNames $VM.SubnetNames |
            New-AzureVM -ServiceName $VM.ServiceName -VNETNAME $VM.VNETNAME -Location $VM.Location
        }
    }
    }
Else
    {
        Write-Host "The Cloud Service already exist, only the VM will be created" -ForegroundColor Yellow

        # New VM to Existing with Location
        New-AzureVMConfig -Name $VM.name -InstanceSize $VM.InstanceSize -ImageName $VM.ImageName -AvailabilitySetName $VM.AvailabilitySetName | 
        Add-AzureProvisioningConfig -Windows -DisableAutomaticUpdates -AdminUserName $VM.AdminUserName -Password $VM.Password | 
        Set-AzureSubnet -SubnetNames $VM.SubnetNames |
        New-AzureVM -ServiceName $VM.ServiceName
    }