output "function_storage_account_name" {
  value = azurerm_storage_account.function.name
}
output "function_name" {
  value = var.os_type == "Linux" ? azurerm_linux_function_app.main[0].name : azurerm_windows_function_app.main[0].name
}
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
