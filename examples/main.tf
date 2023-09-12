locals {
  location     = "northeurope"
  adds_servers = ["10.0.0.4", "10.0.0.5"]
  dns_servers  = local.adds_servers
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "firewallpolicy-example-rg"
  location = local.location
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "example-log"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

module "firewall-policy" {
  source              = "../"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  firewall_policy = {
    name                     = "example"
    sku                      = "Premium"
    private_ip_ranges        = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "100.64.0.0/10", "200.200.0.0/16"]
    threat_intelligence_mode = "Deny"
    threat_intelligence_allowlist = {
      ip_addresses = ["200.200.0.0/16"]
      fqdns        = ["example.com", "example.net"]
    }
  }

  dns = {
    servers = local.dns_servers
  }

  insights = {
    default_log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
  }
}
