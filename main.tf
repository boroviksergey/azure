# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.63.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Create a resource group vor app
resource "azurerm_resource_group" "rg1" {
    name     = "Linux"
    location = "eastus"
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "linuxstorageaccount" {
    name                        = "linsacc"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
    account_tier                = "Standard"
    account_replication_type    = "RAGRS"
}

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
