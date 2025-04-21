# Azure Function Operational Storage
resource "azurerm_storage_account" "function" {
  name                     = "stfunc${random_string.function_storage.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  tags                     = var.tags
}

/***************************** USER ASSIGNED ************************************/
# Allow User Assigned Identity Access to Function Operational Storage Account
resource "azurerm_role_assignment" "function_user_assigned_storage_contributor" {

  scope                = azurerm_storage_account.function.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_user_assigned_identity.function.principal_id

}

# Allow User Assigned Identity Access to Function Operational Storage Account Blob Storage
resource "azurerm_role_assignment" "function_user_assigned_storage_blob_data_owner" {

  scope                = azurerm_storage_account.function.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.function.principal_id

}

/**************************** SYSTEM ASSIGNED ***********************************/
# Allow System Assigned Identity Access to Function Operational Storage Account
resource "azurerm_role_assignment" "function_system_assigned_storage_contributor" {

  scope                = azurerm_storage_account.function.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_windows_function_app.main[0].identity[0].principal_id

}

# Allow System Assigned Identity Access to Function Operational Storage Account Blob Storage
resource "azurerm_role_assignment" "function_system_assigned_storage_blob_data_owner" {

  scope                = azurerm_storage_account.function.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_windows_function_app.main[0].identity[0].principal_id

}
