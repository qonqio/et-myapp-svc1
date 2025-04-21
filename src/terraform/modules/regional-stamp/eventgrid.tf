# Internal EventGrid Topic
resource "azurerm_eventgrid_topic" "main" {
  name                = "evgt-${var.name}-${var.location}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  input_schema        = "CloudEventSchemaV1_0"
  tags                = var.tags
}

/***************************** P U B ************************************/
/* 
 * Allow Application Code to publish to Internal EventGrid Topic.
 * The C# Code explicitly references the User Assigned Managed Identity
 * When it uses the EventGridClient to publish events.
 */
resource "azurerm_role_assignment" "eventgrid_internal_pub" {

  scope                = azurerm_eventgrid_topic.main.id
  role_definition_name = "EventGrid Data Sender"
  principal_id         = azurerm_user_assigned_identity.function.principal_id

}

/* 
 * Allow Application Code to publish to External EventGrid Topic.
 * The C# Code explicitly references the User Assigned Managed Identity
 * When it uses the EventGridClient to publish events.
 */
resource "azurerm_role_assignment" "eventgrid_external_pub" {

  scope                = data.azurerm_eventgrid_topic.core.id
  role_definition_name = "EventGrid Data Sender"
  principal_id         = azurerm_user_assigned_identity.function.principal_id

}

/***************************** S U B ************************************/
# Allow Application Code to subscribe to Internal EventGrid Topic
locals {
  eventgrid_internal_subscriber_endpoint = var.os_type == "Linux" ? "${azurerm_linux_function_app.main[0].id}/functions/InternalSubscriber" : "${azurerm_windows_function_app.main[0].id}/functions/InternalSubscriber"
}
resource "azurerm_eventgrid_event_subscription" "internal" {

  count = var.eventgrid_subscriptions_enabled ? 1 : 0

  name                  = "evgs-${var.name}-${var.location}-internal"
  scope                 = azurerm_eventgrid_topic.main.id
  event_delivery_schema = "CloudEventSchemaV1_0"

  azure_function_endpoint {
    function_id = local.eventgrid_internal_subscriber_endpoint
  }
}
