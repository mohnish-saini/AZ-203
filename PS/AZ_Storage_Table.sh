Install-Module AzTable
Add-AzAccount

Get-AzLocation | select Location
$location = "southeastasia"

$resourceGroup = "msaz203psrg"
New-AzResourceGroup -ResourceGroupName $resourceGroup -Location $location

storageAccountName = "pshtablestorage2020"
storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Location $location -SkuName Standard_LRS -kind StorageV2
$ctx = $storageAccount.Context

$tableName = "pshtesttable"
New-AzStorageTable –Name $tableName –Context $ctx

Get-AzStorageTable –Context $ctx | select Name


$storageTable = Get-AzStorageTable –Name $tableName –Context $ctx

$cloudTable = (Get-AzStorageTable –Name $tableName –Context $ctx).CloudTable

$partitionKey1 = "partition1"
$partitionKey2 = "partition2"

# add four rows
Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey1 `
    -rowKey ("CA") -property @{"username"="Chris";"userid"=1}

Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey2 `
    -rowKey ("NM") -property @{"username"="Jessie";"userid"=2}

Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey1 `
    -rowKey ("WA") -property @{"username"="Christine";"userid"=3}

Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey2 `
    -rowKey ("TX") -property @{"username"="Steven";"userid"=4}


Get-AzTableRow -table $cloudTable | ft

Get-AzTableRow -table $cloudTable -partitionKey $partitionKey1 | ft

Get-AzTableRow -table $cloudTable `
    -columnName "username" `
    -value "Chris" `
    -operator Equal

Get-AzTableRow `
        -table $cloudTable `
        -customFilter "(userid eq 1)"

Update-AzTableRow

Remove-AzTableRow

Remove-AzStorageTable –Name $tableName –Context $ctx

# Retrieve the list of tables to verify the table has been removed.
Get-AzStorageTable –Context $Ctx | select Name

Remove-AzResourceGroup -Name $resourceGroup
