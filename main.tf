locals {
  tags = merge(var.tags, { ManagedByTerraform = "True" })
}

resource "azurerm_firewall_policy" "default" {
  name                              = "${var.firewall_policy.name}-afwp"
  location                          = var.location
  resource_group_name               = var.resource_group_name
  sku                               = var.firewall_policy.sku
  base_policy_id                    = var.firewall_policy.base_policy_id
  threat_intelligence_mode          = var.firewall_policy.threat_intelligence_mode
  private_ip_ranges                 = var.firewall_policy.private_ip_ranges
  auto_learn_private_ranges_enabled = var.firewall_policy.auto_learn_private_ranges_enabled
  sql_redirect_allowed              = var.firewall_policy.sql_redirect_allowed
  tags                              = local.tags

  # Threat Intelligence in Azure portal
  dynamic "threat_intelligence_allowlist" {
    for_each = var.firewall_policy.threat_intelligence_allowlist != null ? [var.firewall_policy.threat_intelligence_allowlist] : []
    content {
      ip_addresses = threat_intelligence_allowlist.value.ip_addresses
      fqdns        = threat_intelligence_allowlist.value.fqdns
    }
  }

  # DNS in Azure portal
  dynamic "dns" {
    for_each = var.dns != null ? [var.dns] : []
    content {
      servers       = dns.value.servers
      proxy_enabled = dns.value.proxy_enabled
    }
  }

  # TLS inspection in Azure portal
  dynamic "tls_certificate" {
    for_each = var.tls_inspection != null ? [var.tls_inspection.tls_certificate] : []
    content {
      key_vault_secret_id = tls_certificate.value.key_vault_secret_id
      name                = tls_certificate.value.name
    }
  }

  dynamic "identity" {
    for_each = var.tls_inspection != null ? [var.tls_inspection.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # IDPS in Azure portal
  dynamic "intrusion_detection" {
    for_each = var.intrusion_detection != null ? [var.intrusion_detection] : []
    content {
      mode           = intrusion_detection.value.mode
      private_ranges = intrusion_detection.value.private_ranges

      dynamic "signature_overrides" {
        for_each = intrusion_detection.value.signature_overrides != null ? [intrusion_detection.value.signature_overrides] : []
        content {
          id    = signature_overrides.value.id
          state = signature_overrides.value.state
        }
      }

      dynamic "traffic_bypass" {
        for_each = intrusion_detection.value.traffic_bypass != null ? [intrusion_detection.value.traffic_bypass] : []
        content {
          name                  = traffic_bypass.value.name
          protocol              = traffic_bypass.value.protocol
          description           = traffic_bypass.value.description
          destination_addresses = traffic_bypass.value.destination_addresses
          destination_ip_groups = traffic_bypass.value.destination_ip_groups
          destination_ports     = traffic_bypass.value.destination_ports
          source_addresses      = traffic_bypass.value.source_addresses
          source_ip_groups      = traffic_bypass.value.source_ip_groups
        }
      }
    }
  }

  # Explicit proxy in Azure portal
  dynamic "explicit_proxy" {
    for_each = var.explicit_proxy != null ? [var.explicit_proxy] : []
    content {
      enabled         = explicit_proxy.value.enabled
      http_port       = explicit_proxy.value.http_port
      https_port      = explicit_proxy.value.https_port
      enable_pac_file = explicit_proxy.value.enable_pac_file
      pac_file_port   = explicit_proxy.value.pac_file_port
      pac_file        = explicit_proxy.value.pac_file
    }
  }

  #Policy Analytics in Azure portal
  dynamic "insights" {
    for_each = var.insights != null ? [var.insights] : []
    content {
      enabled                            = insights.value.enabled
      default_log_analytics_workspace_id = insights.value.default_log_analytics_workspace_id
      retention_in_days                  = insights.value.retention_in_days

      dynamic "log_analytics_workspace" {
        for_each = insights.value.log_analytics_workspace != null ? [insights.value.log_analytics_workspace] : []
        content {
          id                = log_analytics_workspace.value.workspace_id
          firewall_location = log_analytics_workspace.value.firewall_location
        }
      }
    }
  }
}
