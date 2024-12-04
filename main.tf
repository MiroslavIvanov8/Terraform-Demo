terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "99a705e7-c95c-4a3c-9930-9e1a66cc0b8a"
  features {
  }
}

resource "azurerm_resource_group" "mirorg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_service_plan" "miroasp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.mirorg.name
  location            = azurerm_resource_group.mirorg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "mirowebapp" {
  name                = var.app_server_name
  resource_group_name = azurerm_resource_group.mirorg.name
  location            = azurerm_service_plan.miroasp.location
  service_plan_id     = azurerm_service_plan.miroasp.id
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlservermi.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sqldb.name};User ID=${azurerm_mssql_server.sqlservermi.administrator_login};Password=${azurerm_mssql_server.sqlservermi.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
}

resource "azurerm_mssql_server" "sqlservermi" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.mirorg.name
  location                     = azurerm_resource_group.mirorg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_login_pass
}

resource "azurerm_mssql_firewall_rule" "mirofwrule" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.sqlservermi.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "sqldb" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.sqlservermi.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  enclave_type   = "VBS"
  zone_redundant = false

}

resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.mirowebapp.id
  repo_url               = var.github_repo_url
  branch                 = "main"
  use_manual_integration = true
}
