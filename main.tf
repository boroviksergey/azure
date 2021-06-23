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
resource "azurerm_storage_container" "linuxstoragecontainer" {
  name   = "tfcontainer"
  storage_account_name = azurerm_storage_account.linuxstorageaccount.name
}
