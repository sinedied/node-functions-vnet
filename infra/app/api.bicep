@description('Specifies the name of the virtual network.')
param name string

@description('Specifies the location.')
param location string = resourceGroup().location

param tags object = {}

param appServicePlanId string
param storageAccountName string
param virtualNetworkSubnetId string
param applicationInsightsName string
param allowedOrigins array

@secure()
param cosmosDbConnectionString string

var useVnet = !empty(virtualNetworkSubnetId)


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
    applicationInsightsName: applicationInsightsName
    virtualNetworkSubnetId: virtualNetworkSubnetId
    appSettings: {
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
    applicationInsightsName: applicationInsightsName
    managedIdentity: true
    storageManagedIdentity: true
    alwaysOn: false
    appSettings: {
    }
  }
}

// Link the Function App to the Static Web App
// module linkedBackend './app/linked-backend.bicep' = {
//   name: 'linkedbackend'
//   scope: resourceGroup
//   params: {
//     staticWebAppName: webapp.outputs.name
//     functionAppName: api.outputs.name
//     functionAppLocation: location
//   }
// }

output identityPrincipalId string = useVnet ? apiFlex.outputs.identityPrincipalId : api.outputs.identityPrincipalId
output name string = useVnet ? apiFlex.outputs.name : api.outputs.name
output uri string = useVnet ? apiFlex.outputs.uri : api.outputs.uri
