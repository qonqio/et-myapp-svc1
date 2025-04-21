variable "location" {
  type = string
}
variable "name" {
  type = string
}
variable "application_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "core_name" {
  type = string
}
variable "number" {
  type = number
}
variable "os_type" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "terraform_identity" {
  type = object({
    tenant_id = string
    object_id = string
  })
}
variable "secrets" {
  type    = map(string)
  default = {}
}
variable "eventgrid_subscriptions_enabled" {
  type = bool
}