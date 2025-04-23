data "azurerm_resource_group" "shared" {
  name = "rg-${var.core_name}-${var.core_env}"
}
data "azurerm_application_insights" "shared" {
  name                = "appi-${var.core_name}-${var.core_env}"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_resource_group" "core" {
  name = "rg-${var.core_name}-${var.core_env}-${var.location}"
}
data "azurerm_service_plan" "core" {
  name                = "asp-${var.core_name}-${var.core_env}-${var.location}"
  resource_group_name = data.azurerm_resource_group.core.name
}
data "azurerm_key_vault" "core" {
  name                = "kv-${var.core_name}-${var.core_env}1"
  resource_group_name = data.azurerm_resource_group.core.name
}
data "azurerm_eventgrid_topic" "core" {
  name                = "evgt-${var.core_name}-${var.core_env}-${var.location}"
  resource_group_name = data.azurerm_resource_group.core.name
}
