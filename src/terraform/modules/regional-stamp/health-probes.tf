# Liveness Health Probe
resource "azurerm_application_insights_standard_web_test" "liveness" {

  name                    = "${var.name}-${var.location}-live"
  location                = data.azurerm_resource_group.shared.location
  resource_group_name     = data.azurerm_resource_group.shared.name
  application_insights_id = data.azurerm_application_insights.shared.id

  frequency     = 300 # Run test every 5 minutes
  timeout       = 30  # 30 seconds timeout
  enabled       = true
  geo_locations = ["us-fl-mia-edge", "us-va-ash-azr"]

  request {
    url = "https://${azurerm_windows_function_app.main[0].default_hostname}/api/health/live"
  }

}

# Readiness Health Probe
resource "azurerm_application_insights_standard_web_test" "readiness" {

  name                    = "${var.name}-${var.location}-ready"
  location                = data.azurerm_resource_group.shared.location
  resource_group_name     = data.azurerm_resource_group.shared.name
  application_insights_id = data.azurerm_application_insights.shared.id

  frequency     = 300 # Run test every 5 minutes
  timeout       = 30  # 30 seconds timeout
  enabled       = true
  geo_locations = ["us-fl-mia-edge", "us-va-ash-azr"]

  request {
    url = "https://${azurerm_windows_function_app.main[0].default_hostname}/api/health/ready"
  }

}
