# Azure infrastructure deployment with Bicep 

![Bicep](https://img.shields.io/badge/Bicep-azure-blue)
![Azure CLI](https://img.shields.io/badge/Azure%20CLI-azure-blue)

## Project description 

This project creates an Azure infrastructure with Bicep across three environments: dev, test, and prod.  
It includes Resource Groups, Storage Accounts, App Service Plans with Web Apps, a Key Vault for secrets, and Autoscale for production.  
All resources are modularized, parameterized, use environment-specific names, have tags (`owner`, `environment`, `costCenter`), and provide outputs for Web App URLs, App Service Plan IDs, Storage Account IDs, and Key Vault secrets, fulfilling all functional and advanced requirements of the school assignment.

The infrastructure includes: 
- Resource Group (given from the school)
- Storage Account per environment (dev, test, prod)
- App Service Plan + Web App per environment 
- Key Vault for storing secrets 
- Autoscale settings (only for prod)
- Proper tagging (owner`, `environment`, `costCenter`)
- Parameters to have a modular and reusable deployment


## Table of contents
1. [Prerequisites](#prerequisites)  
2. [Repository Structure](#repository-structure)  
3. [Deployment Instructions](#deployment-instructions)  
4. [Notes](#notes)  
5. [Outputs](#outputs)  
6. [Screenshots](#screenshots)  

---

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
└── storage.bicep                  # Storage account 
 main.bicep                        # Orchestrates all modules and deploys resources

/parameters                         # Contains environment-specific parameter files
│
├── dev.json                       # Parameters for development
├── prod.json                      # Parameters for production
└── test.json                      # Parameters for testing

/.gitignore                        # Git ignore rules               

/README.md                         # Readme file (this file)
```

## Deployment instructions 

Deploy each environment separately (dev, test, prod) on your personal Resource Group 

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
- `secretValueFromCLI` to have a secret Key Value passed securely at deployment and not exposed in a parameter file
- All resources are tagged with `owner`, `environment`, and `costCenter`
- Autoscale is enabled only in production
- Resources names include the environment (`dev`, `test`, `prod`) and use `uniqueString()` where required

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
- Screenshot of my RG showing all resources for dev, test, and prod 
![Dev Resources]()
![Test Resources]()
![Prod Resources]()

- Screenshot of deployment output in CLI showing Web App URLs 
![CLI Output]()

- Web App URLs for references: 
    - Dev: 
    - Test: 
    - Prod: 