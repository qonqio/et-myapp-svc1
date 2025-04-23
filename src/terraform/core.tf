data "azurerm_resource_group" "shared" {
  name = "rg-${var.core_name}-${var.core_env}"
}
data "azurerm_application_insights" "shared" {
  name                = "appi-${var.core_name}-${var.core_env}"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_resource_group" "primary" {
  name = "rg-${var.core_name}-${var.core_env}-${var.primary_location}"
}
data "azurerm_service_plan" "primary" {
  name                = "asp-${var.core_name}-${var.core_env}-${var.primary_location}"
  resource_group_name = data.azurerm_resource_group.primary.name
}
data "azurerm_key_vault" "primary" {
  name                = "kv-${var.core_name}-${var.core_env}1"
  resource_group_name = data.azurerm_resource_group.primary.name
}
