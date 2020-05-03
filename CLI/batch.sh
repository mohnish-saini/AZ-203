az group create --name msaz203clirg --location southeastasia

az storage account create \
  --resource-group msaz203clirg \
  --name msaz203storageacc1 \
  --location southeastasia \
  --sku Standard_LRS \
  --kind StorageV2

#Create a Batch account
az batch account create \
  --name msaz203batchaccount \
  --resource-group msaz203clirg \
  --location southeastasia \
  --storage-account msaz203storageacc1

az batch account login \
  --name msaz203batchaccount \
  --resource-group msaz203clirg \
  --shared-key-auth

az batch pool create \
  --id myPool  --vm-size STANDARD_A1_v2 \
  --target-dedicated-nodes 1 \
  --image "MicrosoftWindowsServer:WindowsServer:2016-Datacenter:latest" \
  --node-agent-sku-id "batch.node.windows amd64"

  az batch pool show --pool-id mypool \
    --query "allocationState"

  #resizing, steady


  az batch pool create \
    --id myPool1 --vm-size Standard_A1_v2 \
    --target-dedicated-nodes 1 \
    --image canonical:ubuntuserver:16.04-LTS \
    --node-agent-sku-id "batch.node.ubuntu 16.04"


#Create a Job
az batch job create \
  --id myJob --pool-id myPool1

  #Create a Task

for i in {1..4}
  do
      az batch task create \
        --task-id myTask$i \
        --job-id myJob \
        --command-line "/bin/bash -c 'printenv | grep AZ_BATCH; sleep 10s'"
  done

# task status
az batch task show \
  --job-id myJob \
  --task-id myTask1

  # task output

  az batch task file list \
      --job-id myJob \
      --task-id myTask1 \
      --output table


az batch pool delete --pool-id mypool
az group delete --name myResourceGroup
