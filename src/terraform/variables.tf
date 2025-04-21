variable "application_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "primary_location" {
  type = string
}
variable "os_type" {
  type = string
}
variable "core_name" {
  type = string
}
variable "additional_tags" {
  type = map(string)
  default = {}
}
variable "eventgrid_subscriptions_enabled" {
  type = bool
}