az appservice list-locations --sku B1
az appservice list-locations --sku B1 --linux-workers-enabled

az appservice plan create \
  --name msappserviceplanlinux --resource-group msaz203portalrg-new \
  --sku F1 --is-linux

az webapp create --resource-group msaz203portalrg-new \
  --plan msappserviceplanlinux --name mswebappdemo \
  --deployment-container-image-name NGINX OR --runtime "DOTNETCORE|LTS" --deployment-local-git




  az webapp list-runtimes --linux
  az webapp list-runtimes
