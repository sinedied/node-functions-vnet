# node-functions-vnet

[![Open project in GitHub Codespaces](https://img.shields.io/badge/Codespaces-Open-blue?style=flat-square&logo=github)](https://codespaces.new/sinedied/node-functions-vnet?hide_repo_select=true&ref=main&quickstart=true)

A minimal test project using SWA + Azure Functions + CosmosDB to demonstrate optional VNet integration.

## Deployment

### Prerequisites
- [Azure Account](https://azure.microsoft.com/en-us/free/) (sign up for free)
- [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd?tabs=winget-windows%2Cbrew-mac%2Cscript-linux&pivots=os-windows)
- [Azure Functions Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Cisolated-process%2Cnode-v4%2Cpython-v2%2Chttp-trigger%2Ccontainer-apps&pivots=programming-language-javascript#install-the-azure-functions-core-tools)

Once you have the prerequisites, log in to your Azure account using the Azure Developer CLI:

```bash
azd auth login
```

### Deploy without VNet or storage managed identity:

```bash
azd up
```

#### Enable storage managed identity:

```bash
azd env set USE_STORAGE_MANAGED_IDENTITY true
azd provision
```

> [!CAUTION]
> Deployment of Function app with storage managed identity does not work using any CLI tool at the moment.
> You need to deploy it manually following [this guide](https://learn.microsoft.com/en-us/azure/azure-functions/run-functions-from-deployment-package#using-website_run_from_package--url).

### Deploy with VNet + storage managed identity:

> [!WARNING]
> This will use the new [Azure Functions Flex Consumption plan](https://learn.microsoft.com/en-us/azure/azure-functions/flex-consumption-plan), which is currently in preview. Only a few regions are supported for now, so you should use `eastus` for the `location` parameter.

```bash
azd env set USE_VNET true
azd up
```
