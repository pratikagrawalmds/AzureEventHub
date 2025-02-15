output "resource" {
  description = <<-EOT
  "This is the full output for the resource. This is the default output for the module following AVM standards. Review the examples below for the correct output to use in your module."
  Examples:
  - module.eventhub.resource.id
  EOT
  value       = azurerm_eventhub.this
}

output "resource_id" {
  description = "This is the resource id for the EventHub resource."
  value       = azurerm_eventhub.this.id
}

output "private_endpoints" {
  value       = azurerm_private_endpoint.this
  description = "A map of private endpoints. The map key is the supplied input to var.private_endpoints. The map value is the entire azurerm_private_endpoint resource."
}
output "resource_eventhubs" {
  value       = azurerm_eventhub.this
  description = "A map of event hubs.  The map key is the supplied input to var.event_hubs. The map value is the entire azurerm_event_hubs resource."
}