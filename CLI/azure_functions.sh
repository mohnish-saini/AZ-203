storageName=msaz203storageacc
functionAppName=democlifuncapp2020
region=southeastasia

az group create --name msaz203clirg --location $region

az storage account create \
  --name $storageName \
  --location $region \
  --resource-group msaz203clirg \
  --sku Standard_LRS

az functionapp create \
    --name $functionAppName \
    --storage-account $storageName \
    --resource-group msaz203clirg \
    --consumption-plan-location southeastasia

az functionapp delete --name $functionAppName --resource-group msaz203clirg


# Function App Python

storageName=mystorageaccount$RANDOM
functionAppName=myserverlessfunc$RANDOM
region=westeurope
pythonVersion=3.6 #3.7 also supported
resourceGroup=msaz203clirg1

az group create --name $resourceGroup --location $region

az storage account create \
  --name $storageName \
  --location $region \
  --resource-group $resourceGroup \
  --sku Standard_LRS

az functionapp create \
  --name $functionAppName \
  --resource-group $resourceGroup \
  --storage-account $storageName \
  --consuption-plan-location $region \
  --os-type Linux \
  --runtime Python \
  --runtime-version $pythonVersion \
  --functions-version 2





#Supporting Commands

az functionapp list-consumption-locations
