data "azurerm_resource_group" "shared" {
  name = "rg-${var.core_name}-${var.environment_name}"
}
data "azurerm_application_insights" "shared" {
  name                = "appi-${var.core_name}-${var.environment_name}"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_resource_group" "core" {
  name = "rg-${var.core_name}-${var.environment_name}-${var.location}"
}
data "azurerm_service_plan" "core" {
  name                = "asp-${var.core_name}-${var.environment_name}-${var.location}"
  resource_group_name = data.azurerm_resource_group.core.name
}
data "azurerm_key_vault" "core" {
  name                = "kv-${var.core_name}-${var.environment_name}1"
  resource_group_name = data.azurerm_resource_group.core.name
}
data "azurerm_eventgrid_topic" "core" {
  name                = "evgt-${var.core_name}-${var.environment_name}-${var.location}"
  resource_group_name = data.azurerm_resource_group.core.name
}