keyvault_name=msdemokeyvault1
az provider register -n Microsoft.KeyVault

az keyvault create --name $keyvault_name --resource-group msaz203rg2 --location southeastasia \
  --enabled-for-disk-encryption True

az keyvault key create --vault-name $keyvault_name --name myKey --protection software


  read sp_id sp_password <<< $(az ad sp create-for-rbac --query [appId,password] -o tsv)

  # Grant permissions on the Key Vault to the AAD service principal.
  az keyvault set-policy --name $keyvault_name \
      --spn $sp_id \
      --key-permissions wrapKey \
      --secret-permissions set

  # Encrypt the VM disks.
  az vm encryption enable --resource-group msaz203rg2 --name msdemovm \
    --aad-client-id $sp_id \
    --aad-client-secret $sp_password \
    --disk-encryption-keyvault $keyvault_name \
    --key-encryption-key myKey \
    --volume-type all

  # Output how to monitor the encryption status and next steps.
  echo "The encryption process can take some time. View status with:

      az vm encryption show --resource-group msaz203rg2 --name msdemovm --query [osDisk] -o tsv

  When encryption status shows \`Encrypted\`, restart the VM with:

      az vm restart --resource-group msaz203rg2 --name msdemovm"


az vm encryption show --resource-group msaz203rg2 --name msdemovm --query [osDisk] -o tsv

az vm restart --resource-group msaz203rg2 --name msdemovm
