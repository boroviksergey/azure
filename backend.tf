terraform {  
backend "azurerm" {
    resource_group_name  = "Linux"
    storage_account_name = "linsacc"
    container_name       = "tfcontainer"
    key                  = "terraform.tfstate"
  }
}
