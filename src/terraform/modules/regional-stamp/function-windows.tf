resource "azurerm_windows_function_app" "main" {

  count = var.os_type == "Windows" ? 1 : 0

  name                            = "func-${var.name}-${var.location}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  service_plan_id                 = data.azurerm_service_plan.core.id
  storage_account_name            = azurerm_storage_account.function.name
  storage_uses_managed_identity   = true
  key_vault_reference_identity_id = azurerm_user_assigned_identity.function.id
  tags                            = var.tags

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.function.id
    ]
  }

  site_config {
    use_32_bit_worker = false

    application_stack {
      dotnet_version = "v8.0"
    }

    cors {
      allowed_origins     = ["https://portal.azure.com"]
      support_credentials = true
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"               = "dotnet-isolated"
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = 1
    "WEBSITE_RUN_FROM_PACKAGE"               = 1
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "APPLICATIONINSIGHTS_CONNECTION_STRING"  = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.core.name};SecretName=ApplicationInsights-ConnectionString)"
    "FUNCTION_MANAGED_IDENTITY"              = azurerm_user_assigned_identity.function.client_id
    "STORAGE_BLOB_CONNECTION_STRING"         = azurerm_storage_account.data.primary_connection_string
    "STORAGE_QUEUE_CONNECTION_STRING"        = azurerm_storage_account.data.primary_connection_string
    "EVENTGRID_INTERNAL_ENDPOINT"            = azurerm_eventgrid_topic.main.endpoint
    "EVENTGRID_EXTERNAL_ENDPOINT"            = data.azurerm_eventgrid_topic.core.endpoint
  }

}
