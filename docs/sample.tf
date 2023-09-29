module "firewall-policy" {
  source              = "jsathler/firewall-policy/azurerm"
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
