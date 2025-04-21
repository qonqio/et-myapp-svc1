# User Assigned Identity used for Application Code
resource "azurerm_user_assigned_identity" "function" {

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "mi-${var.name}${var.number}"

}
