data "azurerm_resource_group" "shared" {
  name = "rg-${var.core_name}-${var.environment_name}"
}
data "azurerm_application_insights" "shared" {
  name                = "appi-${var.core_name}-${var.environment_name}"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_resource_group" "primary" {
  name = "rg-${var.core_name}-${var.environment_name}-${var.primary_location}"
}
data "azurerm_service_plan" "primary" {
  name                = "asp-${var.core_name}-${var.environment_name}-${var.primary_location}"
  resource_group_name = data.azurerm_resource_group.primary.name
}
data "azurerm_key_vault" "primary" {
  name                = "kv-${var.core_name}-${var.environment_name}1"
  resource_group_name = data.azurerm_resource_group.primary.name
}
