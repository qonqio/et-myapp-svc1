# Internal KeyVault
resource "azurerm_key_vault" "main" {

  name                        = "kv-${var.name}${var.number}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.terraform_identity.tenant_id
  sku_name                    = "standard"
  enable_rbac_authorization   = true

}

# Allow Terraform to manage Internal KeyVault Data Plane
resource "azurerm_role_assignment" "terraform_keyvault_admin" {

  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.terraform_identity.object_id

}

# Add Internal KeyVault Secrets
resource "azurerm_key_vault_secret" "bulk" {

  for_each = var.secrets

  key_vault_id = azurerm_key_vault.main.id
  name         = each.key
  value        = each.value

  depends_on = [azurerm_role_assignment.terraform_keyvault_admin]

}

# Allow Function Access to Internal KeyVault Secrets
resource "azurerm_role_assignment" "function_keyvault_internal_secrets_user" {

  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.function.principal_id

}

# Allow Function Access to CORE KeyVault Secrets
resource "azurerm_role_assignment" "function_keyvault_core_secrets_user" {

  scope                = data.azurerm_key_vault.core.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.function.principal_id

}
