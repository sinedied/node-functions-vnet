# test-func-vnet

A test project using SWA + Azure Functions + CosmosDB to test optional VNet integration.

# Usage

### Deploy without VNet:

```bash
azd up
```

#### Enable storage managed identity:

```bash
azd env set USE_STORAGE_MANAGED_IDENTITY true
```

### Deploy with VNet:

> [!WARNING]
> This will use the new [Azure Functions Flex Consumption plan](https://learn.microsoft.com/en-us/azure/azure-functions/flex-consumption-plan), which is currently in preview. Only a few regions are supported for now, so you should use `eastus` for the `location` parameter.

```bash
azd env set USE_VNET true
```
