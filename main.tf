resource "azurerm_eventhub_namespace" "this" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity
  dynamic "identity" {

    for_each = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? { this = var.managed_identities } : {}

    content {
      type         = identity.value.system_assigned && length(identity.value.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(identity.value.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
  tags = merge(local.tags, var.tags)
}

resource "azurerm_eventhub" "this" {
  name              = var.eventhub_name
  namespace_id      = azurerm_eventhub_namespace.this.id
  partition_count   = var.partition_count
  message_retention = var.message_retention
  dynamic "capture_description" {
    for_each = var.capture_description != null ? ["capture_description"] : []
    content {
      dynamic "destination" {
        for_each = var.capture_description.destination != null ? ["destination"] : []
        content {
          archive_name_format = var.capture_description.destination.archive_name_format
          blob_container_name = var.capture_description.destination.blob_container_name
          name                = var.capture_description.destination.name
          storage_account_id  = var.capture_description.destination.storage_account_id
        }
      }
      enabled             = var.capture_description.enabled
      encoding            = var.capture_description.encoding
      interval_in_seconds = lookup(var.capture_description, "interval_in_seconds", 300)
      size_limit_in_bytes = lookup(var.capture_description, "size_limit_in_bytes", 314572800)
      skip_empty_archives = lookup(var.capture_description, "skip_empty_archives", false)
    }
  }
}

resource "azurerm_eventhub_authorization_rule" "this" {
  for_each            = var.authorization_rules
  name                = each.value.name != null ? each.value.name : each.key
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this.name
  resource_group_name = var.resource_group_name
  listen              = each.value.manage ? true : each.value.listen
  send                = each.value.manage ? true : each.value.send
  manage              = each.value.manage
}

