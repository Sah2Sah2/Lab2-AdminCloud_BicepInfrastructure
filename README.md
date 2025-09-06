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
- Proper tagging (`owner`, `environment`, `costCenter`)
- Parameters to have a modular and reusable deployment


## Table of contents
1. [Prerequisites](#prerequisites)  
2. [Repository structure](#repository-structure)  
3. [Deployment instructions](#deployment-instructions)  
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
/docs                            
└── cli-outputs.pdf                # Contains a PDF with the CLI outputs 

/src                              
├── main.bicep                     # Orchestrates all modules and deploys resources
└── modules                        # Reusable Bicep modules
    ├── appservice.bicep           # App Service 
    ├── autoscale.bicep            # Autoscale
    ├── keyvault.bicep             # Key Vault
    ├── rg.bicep                   # Resource Group (RG)
    └── storage.bicep              # Storage account 

/parameters                        # Contains environment-specific parameter files
│
├── dev.json                       # Parameters for development
├── prod.json                      # Parameters for production
└── test.json                      # Parameters for testing

/.main.json                        # not commited
/.gitignore                        # Git ignore rules               
/README.md                         # Readme file (this file)
```
**main.bicep**  
This file orchestrates all modules inside `modules/` and deploys the complete infrastructure for the selected environment (dev, test, prod).  
View the full file here: [src/main.bicep](src/main.bicep)

## Validate Bicep files
Before deploying, you can build and lint the Bicep files to make sure everything is correct: 

```bash
# Build the Bicep file to ARM template
az bicep build --file ./src/main.bicep

# Lint the Bicep file for warnings
az bicep lint --file ./src/main.bicep

# Simulate deployment with what-if
az deployment group what-if \
  --resource-group RG-yourname \
  --template-file ./src/main.bicep \
  --parameters @parameters/dev.json \
  --parameters secretValueFromCLI="secretvalue"
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
- `secretValueFromCLI` is used to pass a secret value securely at deployment without exposing it in parameter files
- All resources are tagged with `owner`, `environment`, and `costCenter`
- Autoscale is enabled only in production
- Resource names include the environment (`dev`, `test`, `prod`) and use `uniqueString()` for globally unique resources where required

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
> Note: All resources were deployed temporarily to demonstrate functionality. Screenshots are provided as proof since resources were deleted immediately after deployment to avoid costs.

- Screenshot of my RG showing all resources for dev, test, and prod 
![Alt text](https://github.com/user-attachments/assets/d8e7601b-57d5-4d1e-9b9c-9b5d2a3904a9)

- Screenshot of deployment output in CLI showing Web App URLs 
[Download CLI Output PDF](docs/cli-output.pdf)

- Web App URLs for references: 
    - Dev: https://devapp-web-dev-c3un7w4qzrlpm.azurewebsites.net/
    - Test: https://testapp-web-test-c3un7w4qzrlpm.azurewebsites.net/
    - Prod: https://prodapp-web-prod-c3un7w4qzrlpm.azurewebsites.net/
    - kv: https://prodapp-kv-prod.vault.azure.net/secrets/MySecret-c3un7w4qzrlpm/613cad43c5874a28966dc350934934e6

> Note: Web Apps were deployed temporarily to demonstrate functionality. URLs are not permanent.
