# Azure infrastucture deployment with Bicep 

![Bicep](https://img.shields.io/badge/Bicep-azure-blue)
![Azure CLI](https://img.shields.io/badge/Azure%20CLI-azure-blue)

## Project description 

This project.... 

The infrasture includes: 
- Resource Group (given from the school)
- Storage Account per environment (dev, test, prod)
- App Service Plan + Web App per environment 
-Key Vault for storing secrets 
- Autosclae sertings (only for prod)
- Proper tagging (owner`, `environemnt`, `costCenter`)
- Parameters to have a modular and reusable deployment


## Table of contents

## Prerequisites 
- Azure subscription
- Azure CLI installed
- Bicep CLI installed 
- Permissions to create resource groups and deploy resources

## Repository structure 

```text
/modules                           # Contains reusable Bicep modules
│
├── appservice.bicep               # App Service 
├── autoscale.bicep                # Autoscale
├── keyvault.bicep                 # Key Vault
├── rg.bicep                       # RG 
└── storage.bicep                  # Storace account 
 main.bicep                        # Orchestrates all modules and deploys resources

/parameters                         # Contains environment-specific parameter files
│
├── dev.json                       # Parameters for development
├── prod.json                      # Parameters for production
└── test.json                      # Parameters for testing

/.gitignore                       # Git ignore rules               

/README.md                        # Readme file
```

## Deployment instructions 

Deploy each environment separately (dev, test, prod) on your personal Resouece Group 

Dev

```bash
az deployment group create \
  --resource-group RG-yourname \
  --template-file src/main.bicep \
  --parameters @parameters/dev.json \
  --parameters secretValueFromCLI="secretvalue"
```

Test

```bash
az deployment group create \
  --resource-group RG-yourname \
  --template-file src/main.bicep \
  --parameters @parameters/test.json \
  --parameters secretValueFromCLI="secretvalue1"
```

Prod

```bash
az deployment group create \
  --resource-group RG-yourname \
  --template-file src/main.bicep \
  --parameters @parameters/prod.json \
  --parameters secretValueFromCLI="secretvalue2"
```

## Notes 
- `secretValueFromCli` to have a secret Key Value not exposed in JSON file
- All resources are tagged with `owner`, `environemnt`, and `costCenter`
- Autoscale is enable only in production

## Outputs 
After deployment, the following are available 
- Web App URL for each environment 
- App Service Plan ID
- Storage Account ID
- Key Vault Secret URI

Command to show the outputs: 
```bash
az deployment group show \
  --resource-group RG-yourname \
  --name <deployment-name> \
  --query properties.outputs
```

## Screenshots
- Screenshots showing resources for dev, test, and prod 
- CLI output showing Web App URLs 