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
        rules: [
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: targetResourceId
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 70
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: targetResourceId
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 30
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
        ]
      }
    ]
  }
  tags: {
    owner: owner
    environment: environment
    costCenter: costCenter
  }
}

//--------------------OUTPUTS-----------------

output autoscaleId string = autoscale.id
output autoscaleName string = autoscale.name
