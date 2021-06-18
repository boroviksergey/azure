# create app service plan
resource "azurerm_app_service_plan" "appsplan" {
  name = "linserviceplan"
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Basic"
    size = "B1"
  }
}

# create app-service
resource "azurerm_app_service" "appservice1" {
  name = "linappservice"
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  app_service_plan_id = azurerm_app_service_plan.appsplan.id
  site_config {
    linux_fx_version = "DOTNETCORE|5.0"
  }
}
