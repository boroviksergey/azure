terraform {  
backend "azurerm" {
    resource_group_name  = "Linux"
    storage_account_name = "linsacc"
    container_name       = "tfcontainer"
    key                  = "+erMc2SuIMM40kezsAUD/vIvRH18srQ8Hf+BnofuDellc8ZalGVwEp5851JWktJ3o/5xvOYJ30NfMOTbjGGsEA=="
  }
}
