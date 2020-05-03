az vm -h
az group create --name ms-az203-rg --location southeastasia
az vm list-sizes
az vm list-sizes --location southeastasia
az vm list-sizes --location southeastasia --output table

az vm create --resource-group ms-az203-rg --name msdemovm1 --image win2019datacenter --admin-username msdemo1vmuser --admin-password msdemovm1pwd@123 --size Standard_B1ms


az vm list

az vm open-port --resource-group ms-az203-rg --name msdemovm1 --port 3389 --priority 100

az group delete --name msaz203rg1


#Fully configured VM

# Create a resource group.
az group create --name msaz203rg2 --location southeastasia

# Create a virtual network.
az network vnet create --resource-group msaz203rg2 --name myVNet --subnet-name mySubnet

# Create a public IP address.
az network public-ip create --resource-group msaz203rg2 --name myPublicIp

# Create a network security group.
az network nsg create --resource-group msaz203rg2 --name myNSG

# Create a virtual network card and associate with public IP address and NSG.
az network nic create \
  --resource-group msaz203rg2 \
  --name myNIC \
  --vnet-name myVNet \
  --subnet mySubnet \
  --network-security-group myNSG \
  --public-ip-address myPublicIp


# Create a virtual machine.

az vm create \
  --resource-group msaz203rg2 \
  --name msdemovm \
  --location southeastasia \
  --image win2016datacenter  \
  --nics myNIC \
  --admin-username msdemovmuser \
  --admin-password msdemovmpwd@123

az vm open-port --port 3389 --resource-group msaz203rg2 --name msdemovm


# Create a Linux VM

az group create --name msaz203rg2 --location southeastasia

az vm create --resource-group msaz203rg2 --name mslinuxdemovm --image UbuntuLTS --generate-ssh-keys

az vm create --resource-group msaz203rg2 --name mslinuxdemovm --image UbuntuLTS   \
  --admin-username mslinuxdemovm \
  --admin-password mslinuxdemovm@123

az vm open-port --port 80 --resource-group msaz203rg2 --name mslinuxdemovm

  # update package source
  apt-get -y update

  # install NGINX
  apt-get -y install nginx
