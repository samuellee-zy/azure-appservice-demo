terraform {
    cloud {
        organization = "samuelleezy-hashicorp-demo"
        hostname = "app.terraform.io"

        workspaces {
            name = "azure-pass"
        }
    }
}

# Azure Resource Manager Provider
provider "azurerm" {
    features {}
}

# Create new Resource Group
resource "azurerm_resource_group" "group" {
    name        = "sampleWebApp"
    location    = "westus"    
}

# Create an App Service Plan with Linux
resource "azurerm_app_service_plan" "appServicePlan" {
    name                = azurerm_resource_group.group.name
    location            = azurerm_resource_group.group.location
    resource_group_name = azurerm_resource_group.group.name

    # Define Linux as Host OS
    kind = "Linux"

    # Define size
    sku {
        tier    = "Standard"
        size    = "S1"
    }

    # properties = {
        reserved = true # Mandatory for Linux plans
    #}
}

# Create Azure Web App for Containers in App Service Plan
resource "azurerm_app_service" "webAppContApp" {
    name = azurerm_resource_group.group.name
    location = azurerm_resource_group.group.location
    resource_group_name = azurerm_resource_group.group.name
    app_service_plan_id = azurerm_app_service_plan.appServicePlan.id
    
    # Configure Docker Image to load on start
    site_config {
        linux_fx_version = "DOCKER|microsoft/aci-helloworld:latest"
        always_on = "true"
    }

    identity {
      type = "SystemAssigned"
    }
}



