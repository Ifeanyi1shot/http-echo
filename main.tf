terraform {    
  required_providers {    
    azurerm = {    
      source = "hashicorp/azurerm"    
    }    
  }    
} 
# Provider block to configure the Azure provider with necessary credentials.
provider "azurerm" {    
  features {}    

}
terraform {
  backend "azurerm"{
      resource_group_name  = "walure-group"
      storage_account_name = "rezumii"
      container_name       = "terraform"
  }
}
# Resource block for creating an Azure resource group.
resource "azurerm_resource_group" "resource_group" {
  name     = "dev-containers-demo"
  location = "northeurope"
}
# Resource block for creating an Azure App Service Plan.
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "ASP-waluregroup-9613"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  # Define Linux as Host OS
  kind = "Linux"
  reserved = true  # Set reserved to true for Linux App Service Plans

  # Choose size
  sku {
    tier = "Basic"
    size = "B1"
    capacity = 1    
  }

}

# Resource block for creating an Azure App Service for staging.
resource "azurerm_app_service" "app_service" {
  name                = "httpecho-demo"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  # Configuration settings for the App Service.
  app_settings = {
   WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = "https://hub.docker.com/r/hashicorp/http-echo/"
    DOCKER_REGISTRY_SERVER_USERNAME = "smartwarewalure"
    DOCKER_REGISTRY_SERVER_PASSWORD = "Pyth6789."


  
  }
  # Configure Docker Image to load on startcd 
  site_config {
    linux_fx_version = "DOCKER|hashicorp/http-echo:latest"
    always_on        = "true"
  }

}
# Resource block for creating an another Azure App Service for production.
resource "azurerm_app_service" "another_app_service" {
  name                = "httpecho-prod"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  # Configuration settings for the App Service.
  app_settings = {
   WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = "https://hub.docker.com/r/hashicorp/http-echo/"
    DOCKER_REGISTRY_SERVER_USERNAME = "smartwarewalure"
    DOCKER_REGISTRY_SERVER_PASSWORD = "Pyth6789."


  
  }
  # Configure Docker Image to load on startcd 
  site_config {
    linux_fx_version = "DOCKER|hashicorp/http-echo:latest"
    always_on        = "true"
  }

}

