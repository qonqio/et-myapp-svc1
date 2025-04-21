resource "azurerm_linux_function_app" "main" {

  count = var.os_type == "Linux" ? 1 : 0

  name                = "func-${var.name}-${var.location}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags

  storage_account_name            = azurerm_storage_account.function.name
  storage_uses_managed_identity   = true
  service_plan_id                 = data.azurerm_service_plan.core.id
  key_vault_reference_identity_id = azurerm_user_assigned_identity.function.id

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.function.id
    ]
  }

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
    cors {
      allowed_origins     = ["https://portal.azure.com"]
      support_credentials = true
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"              = "dotnet-isolated"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"        = "false"
    "WEBSITE_RUN_FROM_PACKAGE"              = 1
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.core.name};SecretName=ApplicationInsights-ConnectionString)"
  }

}
