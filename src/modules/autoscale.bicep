// ===============autoscale.bicep =============

targetScope = 'resourceGroup'

@description('Autoscale setting name')
param autoscaleName string 

@description('Minimun instance count')
param minInstanceCount int 

@description('Max instance count')
param maxInstanceCount int 

@description('Default instance count')
param defaultInstanceCount int 

@description('Target resource')
param targetResourceId string 

@description('owner tag')
param owner string 

@description('Environment tag')
param environment string 

@description('Cost center tag')
param costCenter string

resource autoscale 'Microsoft.Insights/autoscalesettings@2022-10-01' = {
  name: autoscaleName
  location: resourceGroup().location
  properties: {
    targetResourceUri: targetResourceId
    enabled: true
    profiles: [
      {
        name: 'DefaultProfile'
        capacity: {
          minimum: string(minInstanceCount)
          maximum: string(maxInstanceCount)
          default: string(defaultInstanceCount)
        }
        rules: []
      }
    ]
  }
  tags: {
    owner: owner
    environment: environment
    costCenter: costCenter
  }
}

// Outputs 

output autoscaleId string = autoscale.id
output autoscaleName string = autoscale.name
