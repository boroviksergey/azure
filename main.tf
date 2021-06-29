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
    lifecycle {
    prevent_destroy = true
  }
}

