terraform {
    backend "azurerm" {
        resource_group_name = "backend-rg"
        storage_account_name = "backendsta"
        container_name = "backendcontainer"
        key = "dev.tfstate" 
     subscription_id       = "81cc1915-8d88-419e-8fa3-0178811761bd"
    use_azuread_auth      = true
    }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}

provider "azurerm" {
  features {} 
  subscription_id = "81cc1915-8d88-419e-8fa3-0178811761bd"
}