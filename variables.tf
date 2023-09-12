variable "location" {
  description = "The region where the Azure Firewall will be created. This parameter is required"
  type        = string
  default     = "northeurope"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Azure Firewall will be created. This parameter is required"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources. This parameter is optional"
  type        = map(string)
  default     = null
}

variable "firewall_policy" {
  description = <<DESCRIPTION
  Common policy parameters. This parameter is required'
  - name:                               (required) The name which should be used for this Firewall Policy.
  - sku:                                (optional) The SKU Tier of the Firewall Policy. Possible values are 'Standard' and 'Premium'. Defaults to 'Standard'
  - private_ip_ranges:                  (optional) A list of private IP ranges to which traffic will not be SNAT. If you set this parameter, you need to add RFC1918 addresses if
                                                    you don't wan't to SNAT private addresses. If you specify '255.255.255.255/32' SNAT will always be performed. 
                                                    If you specify '0.0.0.0/0' SNAT will never be performed.
  - auto_learn_private_ranges_enabled:  (optional) Whether enable auto learn private ip range. Defaults to null
  - base_policy_id:                     (optional) The ID of the base Firewall Policy
  - sql_redirect_allowed:               (optional) Whether SQL Redirect traffic filtering is allowed. Enabling this flag requires no rule using ports between 11000-11999. Defaults to 'null'
  - threat_intelligence_mode:           (optional) The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. Defaults to Alert
  - threat_intelligence_allowlist:      (optional) A block as defined bellow
    - ip_addresses:                     (optional) A list of IP addresses or IP address ranges that will be skipped for threat detection
    - fqdns:                            (optional) A list of FQDNs that will be skipped for threat detection
  DESCRIPTION

  type = object({
    name                              = string
    sku                               = optional(string, "Standard")
    private_ip_ranges                 = optional(list(string), null)
    auto_learn_private_ranges_enabled = optional(bool, null)
    base_policy_id                    = optional(string, null)
    sql_redirect_allowed              = optional(bool, null)
    threat_intelligence_mode          = optional(string, "Alert")
    threat_intelligence_allowlist = optional(object({
      ip_addresses = optional(list(string), null)
      fqdns        = optional(list(string), null)
    }), null)
  })
}

variable "dns" {
  description = <<DESCRIPTION
  DNS parameters. Defaults to 'null'
  - servers                           (optional) A list of custom DNS servers' IP addresses
  - proxy_enabled                     (optional) Whether to enable DNS proxy on Firewalls attached to this Firewall Policy. Defaults to false
  DESCRIPTION    

  type = object({
    servers       = optional(list(string), null)
    proxy_enabled = optional(bool, false)
  })

  default = null
}

variable "tls_inspection" {
  description = <<DESCRIPTION
  TLS Inspection parameters. Defaults to 'null'
  - tls_certificate:        (optional) A block as defined bellow 
    - key_vault_secret_id:  (required) The ID of the Key Vault, where the secret or certificate is stored
    - name:                 (required) The name of the certificate

  - identity:               (optional) A block as defined bellow 
    - type:                 (optional) Specifies the type of Managed Service Identity that should be configured on this Firewall Policy. Only possible value is UserAssigned. Defaults to 'UserAssigned'
    - identity_ids:         (required) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Firewall Policy.
  DESCRIPTION

  type = object({
    tls_certificate = object({
      key_vault_secret_id = string
      name                = bool
    })

    identity = object({
      type         = optional(string, "UserAssigned")
      identity_ids = list(string)
    })
  })

  default = null
}

variable "intrusion_detection" {
  description = <<DESCRIPTION
  Intrusion detection parameters. Defaults to 'null'
  - name:                   (Required) The name which should be used for this bypass traffic setting.
  - protocol:               (Required) The protocols any of ANY, TCP, ICMP, UDP that shall be bypassed by intrusion detection. Defaults to 'TCP'
  - description:            (Optional) The description for this bypass traffic setting.
  - destination_addresses:  (Optional) Specifies a list of destination IP addresses that shall be bypassed by intrusion detection.
  - destination_ip_groups:  (Optional) Specifies a list of destination IP groups that shall be bypassed by intrusion detection.
  - destination_ports:      (Optional) Specifies a list of destination IP ports that shall be bypassed by intrusion detection.
  - source_addresses:       (Optional) Specifies a list of source addresses that shall be bypassed by intrusion detection.
  - source_ip_groups:       (Optional) Specifies a list of source IP groups that shall be bypassed by intrusion detection.
  DESCRIPTION    

  type = object({
    mode           = optional(string, "Alert")
    private_ranges = optional(list(string), null)

    signature_overrides = optional(object({
      id    = number
      state = string
    }), null)

    traffic_bypass = optional(object({
      name                  = string
      protocol              = optional(string, "TCP")
      description           = optional(string, null)
      destination_addresses = optional(string, null)
      destination_ip_groups = optional(string, null)
      destination_ports     = optional(string, null)
      source_addresses      = optional(string, null)
      source_ip_groups      = optional(string, null)
    }), null)
  })

  default = null
}

variable "explicit_proxy" {
  description = <<DESCRIPTION
  Explicity Proxy parameters. Defaults to 'null'
  - enabled:         (optional) Whether the explicit proxy is enabled for this Firewall Policy. Defaults to 'true'
  - http_port:       (optional) The port number for explicit http protocol. Defaults to '8080'
  - https_port:      (optional) The port number for explicit proxy https protocol. Defaults to '8443'
  - enable_pac_file: (optional) Whether the pac file port and url need to be provided. Defauls to 'null'
  - pac_file:        (optional) Specifies a SAS URL for PAC file. Defauls to 'null'
  - pac_file_port:   (optional) Specifies a port number for firewall to serve PAC file. Defauls to 'null'
  DESCRIPTION

  type = object({
    enabled         = optional(bool, true)
    http_port       = optional(number, 8080)
    https_port      = optional(number, 8443)
    enable_pac_file = optional(bool, null)
    pac_file        = optional(string, null)
    pac_file_port   = optional(number, null)
  })

  default = null
}

variable "insights" {
  description = <<DESCRIPTION
  Workspace parameters for Policy Analytics. Defaults to 'null'
  - workspace_id:      (optional) Specifies the type of Managed Service Identity that should be configured on this Firewall Policy. Only possible value is UserAssigned. Defaults to 'UserAssigned'
  - firewall_location: (required) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Firewall Policy.
  DESCRIPTION

  type = object({
    enabled                            = optional(bool, true)
    default_log_analytics_workspace_id = string
    retention_in_days                  = optional(number, 31)

    log_analytics_workspace = optional(object({
      workspace_id      = string
      firewall_location = string
    }), null)
  })

  default = null
}
