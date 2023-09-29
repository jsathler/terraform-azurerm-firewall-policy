output "policy_id" {
  description = "Firewall policy ID"
  value       = azurerm_firewall_policy.default.id
}

output "policy_name" {
  description = "Firewall policy name"
  value       = azurerm_firewall_policy.default.name
}

output "associated_firewalls" {
  description = "Firewalls associated to this policy"
  value       = azurerm_firewall_policy.default.firewalls
}

output "rule_collection_groups" {
  description = "Existing rule collection groups"
  value       = azurerm_firewall_policy.default.rule_collection_groups
}
