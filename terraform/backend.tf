terraform {
    backend "azurerm" {
        resource_group_name = "tfstate-rg"
        storage_account_name = "tfstate2689"
        container_name = "tfstate"
        key = "project4.terraform.tfstate"
    }
}