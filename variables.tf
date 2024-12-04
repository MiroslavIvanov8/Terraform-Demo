variable "resource_group_name" {
  description = "resource group name"
  type        = string
}
variable "resource_group_location" {
  description = "resource group location"
  type        = string
}
variable "app_service_plan_name" {
  description = "app service plan name"
  type        = string
}
variable "app_server_name" {
  description = "app server name"
  type        = string
}
variable "sql_server_name" {
  description = "sql server name"
  type        = string
}
variable "sql_database_name" {
  description = "sql database name"
  type        = string
}
variable "sql_admin_login" {
  description = "sql admin user"
  type        = string
}
variable "sql_admin_login_pass" {
  description = "sql admin user pass"
  type        = string
}
variable "firewall_rule_name" {
  description = "firewall rule name"
  type        = string
}
variable "github_repo_url" {
  description = "github repo url"
  type        = string
}
