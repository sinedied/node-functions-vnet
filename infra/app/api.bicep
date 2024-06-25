@description('Specifies the name of the virtual network.')
param name string

@description('Specifies the location.')
param location string = resourceGroup().location

param tags object = {}

param appServicePlanId string
param storageAccountName string
param virtualNetworkSubnetId string
param applicationInsightsName string
param applicationInsightsInstrumentationKey string
param allowedOrigins array
param storageManagedIdentity bool
param keyVaultName string
param staticWebAppName string = ''

@secure()
param cosmosDbConnectionString string

var useVnet = !empty(virtualNetworkSubnetId)
var finalApi = useVnet ? apiFlex : api

module apiFlex '../core/host/functions-flex.bicep' = if (useVnet) {
  name: 'api-flex'
  scope: resourceGroup()
  params: {
    name: name
    location: location
    tags: tags
    allowedOrigins: allowedOrigins
    runtimeName: 'node'
    runtimeVersion: '20'
    appServicePlanId: appServicePlanId
    storageAccountName: storageAccountName
    keyVaultName: keyVaultName
    applicationInsightsName: applicationInsightsName
    virtualNetworkSubnetId: virtualNetworkSubnetId
    alwaysOn: false
    appSettings: {
      COSMOSDB_CONNECTION_STRING: cosmosDbConnectionString
      APPINSIGHTS_INSTRUMENTATIONKEY: applicationInsightsInstrumentationKey
    }
  }
}

module api '../core/host/functions.bicep' = if (!useVnet) {
  name: 'api'
  scope: resourceGroup()
  params: {
    name: name
    location: location
    tags: tags
    allowedOrigins: allowedOrigins
    runtimeName: 'node'
    runtimeVersion: '20'
    appServicePlanId: appServicePlanId
    storageAccountName: storageAccountName
    keyVaultName: keyVaultName
    applicationInsightsName: applicationInsightsName
    managedIdentity: true
    storageManagedIdentity: storageManagedIdentity
    scmDoBuildDuringDeployment: !storageManagedIdentity
    enableOryxBuild: !storageManagedIdentity
    alwaysOn: false
    appSettings: {
      COSMOSDB_CONNECTION_STRING: cosmosDbConnectionString
    }
  }
}

// Link the Function App to the Static Web App
module linkedBackend './linked-backend.bicep' = if (!empty(staticWebAppName)) {
  name: 'linkedbackend'
  scope: resourceGroup()
  params: {
    staticWebAppName: staticWebAppName
    backendResourceId: finalApi.outputs.id
    backendLocation: location
  }
}

output identityPrincipalId string = finalApi.outputs.identityPrincipalId
output name string = finalApi.outputs.name
output uri string = finalApi.outputs.uri
