<!-- BEGIN_TF_DOCS -->
# Azure Firewall Policy Terraform module

Terraform module which creates Azure Firewall Policy resources on Azure.

Supported Azure services:

* [Azure Firewall Manager policy](https://learn.microsoft.com/en-us/azure/firewall-manager/policy-overview)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.70.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns"></a> [dns](#input\_dns) | DNS parameters. Defaults to 'null'<br>  - servers                           (optional) A list of custom DNS servers' IP addresses<br>  - proxy\_enabled                     (optional) Whether to enable DNS proxy on Firewalls attached to this Firewall Policy. Defaults to false | <pre>object({<br>    servers       = optional(list(string), null)<br>    proxy_enabled = optional(bool, false)<br>  })</pre> | `null` | no |
| <a name="input_explicit_proxy"></a> [explicit\_proxy](#input\_explicit\_proxy) | Explicity Proxy parameters. Defaults to 'null'<br>  - enabled:         (optional) Whether the explicit proxy is enabled for this Firewall Policy. Defaults to 'true'<br>  - http\_port:       (optional) The port number for explicit http protocol. Defaults to '8080'<br>  - https\_port:      (optional) The port number for explicit proxy https protocol. Defaults to '8443'<br>  - enable\_pac\_file: (optional) Whether the pac file port and url need to be provided. Defauls to 'null'<br>  - pac\_file:        (optional) Specifies a SAS URL for PAC file. Defauls to 'null'<br>  - pac\_file\_port:   (optional) Specifies a port number for firewall to serve PAC file. Defauls to 'null' | <pre>object({<br>    enabled         = optional(bool, true)<br>    http_port       = optional(number, 8080)<br>    https_port      = optional(number, 8443)<br>    enable_pac_file = optional(bool, null)<br>    pac_file        = optional(string, null)<br>    pac_file_port   = optional(number, null)<br>  })</pre> | `null` | no |
| <a name="input_firewall_policy"></a> [firewall\_policy](#input\_firewall\_policy) | Common policy parameters. This parameter is required'<br>  - name:                               (required) The name which should be used for this Firewall Policy.<br>  - sku:                                (optional) The SKU Tier of the Firewall Policy. Possible values are 'Standard' and 'Premium'. Defaults to 'Standard'<br>  - private\_ip\_ranges:                  (optional) A list of private IP ranges to which traffic will not be SNAT. If you set this parameter, you need to add RFC1918 addresses if<br>                                                    you don't wan't to SNAT private addresses. If you specify '255.255.255.255/32' SNAT will always be performed. <br>                                                    If you specify '0.0.0.0/0' SNAT will never be performed.<br>  - auto\_learn\_private\_ranges\_enabled:  (optional) Whether enable auto learn private ip range. Defaults to null<br>  - base\_policy\_id:                     (optional) The ID of the base Firewall Policy<br>  - sql\_redirect\_allowed:               (optional) Whether SQL Redirect traffic filtering is allowed. Enabling this flag requires no rule using ports between 11000-11999. Defaults to 'null'<br>  - threat\_intelligence\_mode:           (optional) The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. Defaults to Alert<br>  - threat\_intelligence\_allowlist:      (optional) A block as defined bellow<br>    - ip\_addresses:                     (optional) A list of IP addresses or IP address ranges that will be skipped for threat detection<br>    - fqdns:                            (optional) A list of FQDNs that will be skipped for threat detection | <pre>object({<br>    name                              = string<br>    sku                               = optional(string, "Standard")<br>    private_ip_ranges                 = optional(list(string), null)<br>    auto_learn_private_ranges_enabled = optional(bool, null)<br>    base_policy_id                    = optional(string, null)<br>    sql_redirect_allowed              = optional(bool, null)<br>    threat_intelligence_mode          = optional(string, "Alert")<br>    threat_intelligence_allowlist = optional(object({<br>      ip_addresses = optional(list(string), null)<br>      fqdns        = optional(list(string), null)<br>    }), null)<br>  })</pre> | n/a | yes |
| <a name="input_insights"></a> [insights](#input\_insights) | Workspace parameters for Policy Analytics. Defaults to 'null'<br>  - workspace\_id:      (optional) Specifies the type of Managed Service Identity that should be configured on this Firewall Policy. Only possible value is UserAssigned. Defaults to 'UserAssigned'<br>  - firewall\_location: (required) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Firewall Policy. | <pre>object({<br>    enabled                            = optional(bool, true)<br>    default_log_analytics_workspace_id = string<br>    retention_in_days                  = optional(number, 31)<br><br>    log_analytics_workspace = optional(object({<br>      workspace_id      = string<br>      firewall_location = string<br>    }), null)<br>  })</pre> | `null` | no |
| <a name="input_intrusion_detection"></a> [intrusion\_detection](#input\_intrusion\_detection) | Intrusion detection parameters. Defaults to 'null'<br>  - name:                   (Required) The name which should be used for this bypass traffic setting.<br>  - protocol:               (Required) The protocols any of ANY, TCP, ICMP, UDP that shall be bypassed by intrusion detection. Defaults to 'TCP'<br>  - description:            (Optional) The description for this bypass traffic setting.<br>  - destination\_addresses:  (Optional) Specifies a list of destination IP addresses that shall be bypassed by intrusion detection.<br>  - destination\_ip\_groups:  (Optional) Specifies a list of destination IP groups that shall be bypassed by intrusion detection.<br>  - destination\_ports:      (Optional) Specifies a list of destination IP ports that shall be bypassed by intrusion detection.<br>  - source\_addresses:       (Optional) Specifies a list of source addresses that shall be bypassed by intrusion detection.<br>  - source\_ip\_groups:       (Optional) Specifies a list of source IP groups that shall be bypassed by intrusion detection. | <pre>object({<br>    mode           = optional(string, "Alert")<br>    private_ranges = optional(list(string), null)<br><br>    signature_overrides = optional(object({<br>      id    = number<br>      state = string<br>    }), null)<br><br>    traffic_bypass = optional(object({<br>      name                  = string<br>      protocol              = optional(string, "TCP")<br>      description           = optional(string, null)<br>      destination_addresses = optional(string, null)<br>      destination_ip_groups = optional(string, null)<br>      destination_ports     = optional(string, null)<br>      source_addresses      = optional(string, null)<br>      source_ip_groups      = optional(string, null)<br>    }), null)<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The region where the Azure Firewall will be created. This parameter is required | `string` | `"northeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the Azure Firewall will be created. This parameter is required | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. This parameter is optional | `map(string)` | `null` | no |
| <a name="input_tls_inspection"></a> [tls\_inspection](#input\_tls\_inspection) | TLS Inspection parameters. Defaults to 'null'<br>  - tls\_certificate:        (optional) A block as defined bellow <br>    - key\_vault\_secret\_id:  (required) The ID of the Key Vault, where the secret or certificate is stored<br>    - name:                 (required) The name of the certificate<br><br>  - identity:               (optional) A block as defined bellow <br>    - type:                 (optional) Specifies the type of Managed Service Identity that should be configured on this Firewall Policy. Only possible value is UserAssigned. Defaults to 'UserAssigned'<br>    - identity\_ids:         (required) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Firewall Policy. | <pre>object({<br>    tls_certificate = object({<br>      key_vault_secret_id = string<br>      name                = bool<br>    })<br><br>    identity = object({<br>      type         = optional(string, "UserAssigned")<br>      identity_ids = list(string)<br>    })<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_associated_firewalls"></a> [associated\_firewalls](#output\_associated\_firewalls) | Firewalls associated to this policy |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | Firewall policy ID |
| <a name="output_policy_name"></a> [policy\_name](#output\_policy\_name) | Firewall policy name |
| <a name="output_rule_collection_groups"></a> [rule\_collection\_groups](#output\_rule\_collection\_groups) | Existing rule collection groups |

## Examples
```hcl
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
```
More examples in ./examples folder
<!-- END_TF_DOCS -->