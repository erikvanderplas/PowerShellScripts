###############################################################################
#
#	Created by:		Erik van der Plas
#	Company: 		Sogeti Netherlands B.V.
#       
# 	Created on:		February 17, 2015
#
#	Version:		0.2
#
#	Azure copy Blob data between authenticated Storage accounts
#
###############################################################################


[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True)]
	[string]$SrcStorageAccount,
    [Parameter(Mandatory=$True)]
	[string]$DestStorageAccount,
    [Parameter(Mandatory=$True)]
	[string]$SrcBlob,
    [Parameter(Mandatory=$True)]
	[string]$DestBlob,
    [Parameter(Mandatory=$True)]
	[string]$SrcContainerName,
    [Parameter(Mandatory=$True)]
	[string]$DestContainerName
)

## Script usage
# .\Azure_Copy_Blob.ps1 -SrcStorageAccount StoragePlas -DestStorageAccount StoragePlas2 -SrcBlob disk.vhd -DestBlob disk_copy.vhd -SrcContainerName vhds -DestContainerName vhdscopy

If (!$ContainerName) {Read-Host "Enter the destination Container"}

###############################################################################
#
#	Get Storage accounts keys
#
###############################################################################


# Get-AzureStorageKey Source
$SrcStorageKey = Get-AzureStorageKey $SrcStorageAccount
 
# Get-AzureStorageKey Destination
$DestStorageKey = Get-AzureStorageKey $DestStorageAccount


###############################################################################
#
#	Get Storage accounts keys
#
###############################################################################


# Source Storage Context
$SrcContext = New-AzureStorageContext –StorageAccountName $SrcStorageAccount -StorageAccountKey $SrcStorageKey.Primary
 
# Destination Storage Context
$DestContext = New-AzureStorageContext –StorageAccountName $DestStorageAccount -StorageAccountKey $DestStorageKey.Primary

### Create the container on the destination ### 

#New-AzureStorageContainer -Name $ContainerName -Context $destContext 


###############################################################################
#
#	Copy Blob Storage
#
###############################################################################


$BlobCopy = Start-AzureStorageBlobCopy -srcUri "https://" +$SrcStorageAccount+ ".blob.core.windows.net/" +$SrcContainerName+ "/" +$SrcBlob -SrcContext $SrcContext -DestContainer $DestContainerName -DestBlob $DestBlob -DestContext $DestContext


<#
### Start the asynchronous copy - specify the source authentication with -SrcContext ### 
$blob3 = Start-AzureStorageBlobCopy -srcUri $srcUri3 `
                                    -SrcContext $srcContext `
                                    -DestContainer $containerName `
                                    -DestBlob "EVDPSTORAGETEST-EVDPSTORAGETEST-2015-02-10.vhd" `
                                    -DestContext $destContext

### Start the asynchronous copy - specify the source authentication with -SrcContext ### 
$blob4 = Start-AzureStorageBlobCopy -srcUri $srcUri1 `
                                    -SrcContext $srcContext `
                                    -DestContainer $containerName `
                                    -DestBlob "EVDPSTORAGETEST-EVDPSTORAGETEST-0210-1.vhd" `
                                    -DestContext $destContext

### Start the asynchronous copy - specify the source authentication with -SrcContext ### 
$blob5 = Start-AzureStorageBlobCopy -srcUri $srcUri2 `
                                    -SrcContext $srcContext `
                                    -DestContainer $containerName `
                                    -DestBlob "EVDPSTORAGETEST-EVDPSTORAGETEST-0210-2.vhd" `
                                    -DestContext $destContext
#>