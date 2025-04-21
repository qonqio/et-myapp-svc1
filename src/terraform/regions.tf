
module "region_stamp_primary" {

  source = "./modules/regional-stamp"

  location                        = var.primary_location
  application_name                = var.application_name
  environment_name                = var.environment_name
  core_name                       = var.core_name
  name                            = "${var.application_name}-${var.environment_name}"
  number                          = 1
  os_type                         = var.os_type
  tags                            = local.all_tags
  eventgrid_subscriptions_enabled = var.eventgrid_subscriptions_enabled

  secrets = {
  }

  terraform_identity = {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
  }

}
