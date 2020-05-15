resourceGroupName=msaz203cosmosdb
location=eastus

cosmosdbaccountname=msaz203cosmosdbaccountcli

az group create --name $resourceGroupName --location $location

az cosmosdb create \
  --resource-group $resourceGroupName \
  --name $cosmosdbaccountname \
  --kind GlobalDocumentDB \
  --locations regionName=$location failoverPriority=0 \
  --locations regionName=westus failoverPriority=1 \
  --default-consistency-level Strong \
  --enable-multiple-write-locations true


az cosmosdb delete \
  --resource-group $resourceGroupName \
  --name $cosmosdbaccountname

# Supporting Commands

az cosmosdb check-name-exists --name msaz203cosmosdbaccountcli

# failover priority chnage

az cosmosdb failover-priority-change --failover-policies regionName=failoverPriority --name MyCosmosDBDatabaseAccount --resource-group MyResourceGroup

# list
az cosmosdb list [--only-show-errors]
                 [--resource-group]
                 [--subscription]

az cosmosdb list-connection-strings [--ids]
                                     [--name]
                                     [--only-show-errors]
                                     [--resource-group]
                                     [--subscription]
az cosmosdb list-connection-strings --name MyCosmosDBDatabaseAccount --resource-group MyResourceGroup


az cosmosdb list-keys [--ids]
                      [--name]
                      [--only-show-errors]
                      [--resource-group]
                      [--subscription]
az cosmosdb list-keys --name MyCosmosDBDatabaseAccount --resource-group MyResourceGroup --subscription MySubscription

az cosmosdb list-read-only-keys [--ids]
                                [--name]
                                [--only-show-errors]
                                [--resource-group]
                                [--subscription]

az cosmosdb list-read-only-keys --name MyCosmosDBDatabaseAccount --resource-group MyResourceGroup

az cosmosdb show [--ids]
                 [--name]
                 [--only-show-errors]
                 [--resource-group]
                 [--subscription]

az cosmosdb show --name MyCosmosDBDatabaseAccount --resource-group MyResourceGroup

az cosmosdb update
