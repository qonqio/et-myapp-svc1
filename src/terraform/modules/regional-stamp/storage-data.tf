
resource "azurerm_storage_account" "data" {
  name                      = "stdata${random_string.function_storage.result}"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  account_tier              = "Standard"
  account_replication_type  = "ZRS"
  shared_access_key_enabled = true
  tags                      = var.tags
}

# Allow Terraform to manage Azure Storage Data Plane
resource "azurerm_role_assignment" "terraform_data_contributor" {

  scope                = azurerm_storage_account.data.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.terraform_identity.object_id

}

# Allow Azure Function User Assigned Managed Identity to access Blob Storage
resource "azurerm_role_assignment" "blob_data_contributor" {

  scope                = azurerm_storage_account.data.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.function.principal_id

}

# Allow Azure Function User Assigned Managed Identity to access Queue Storage
resource "azurerm_role_assignment" "function_queue_data_contributor" {

  scope                = azurerm_storage_account.data.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_user_assigned_identity.function.principal_id

}
