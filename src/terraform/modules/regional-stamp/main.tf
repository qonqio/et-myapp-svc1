resource "random_string" "function_storage" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.name}-${var.location}"
  location = var.location
}
