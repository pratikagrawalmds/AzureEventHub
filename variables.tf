variable "namespace_name" {
  description = "The name of the Event Hub Namespace"
  type        = string
}

variable "location" {
  description = "The location/region of the Event Hub Namespace"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Event Hub Namespace is created"
  type        = string
}

variable "sku" {
  description = "The SKU of the Event Hub Namespace (e.g., Standard, Basic, Premium)"
  type        = string
}

variable "capacity" {
  description = "The capacity for the Event Hub Namespace (e.g., 1, 2, 3)"
  type        = number
}

variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
  Controls the Managed Identity configuration on this resource. The following properties can be specified:

  - `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
  - `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
  DESCRIPTION
  nullable    = false
}


# Variables for the Event Hub
variable "eventhub_name" {
  description = "The name of the Event Hub"
  type        = string
}

variable "partition_count" {
  description = "The number of partitions for the Event Hub"
  type        = number
}

variable "message_retention" {
  description = "The message retention time in days for the Event Hub"
  type        = number
}



variable "authorization_rules" {
  type = map(object({
    name   = optional(string, null)
    listen = optional(bool, false)
    send   = optional(bool, false)
    manage = optional(bool, false)
  }))
  default     = {}
  description = <<DESCRIPTION
  Defaults to `{}`. Manages a EventHub Namespace authorization Rule within a EventHub.

  - `name`   - (Optional) - Defaults to `null`. Specifies the name of the EventHub Namespace Authorization Rule resource. Changing this forces a new resource to be created. If it is null it will use the map key as the name.
  - `send`   - (Optional) - Always set to `true` when manage is `true` if not it will default to `false`. Does this Authorization Rule have Listen permissions to the EventHub Namespace?
  - `listen` - (Optional) - Always set to `true` when manage is `true` if not it will default to `false`. Does this Authorization Rule have Send permissions to the EventHub Namespace? 
  - `manage` - (Optional) - Defaults to `false`. Does this Authorization Rule have Manage permissions to the EventHub Namespace?

  Example Inputs:
  ```hcl
  authorization_rules = {
    testRule = {
      send   = true
      listen = true
      manage = true
    }
  }
  ```
  DESCRIPTION
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags of the resource."
}

variable "capture_description" {
  type = object({
    enabled             = optional(bool, false)
    encoding            = optional(string, "Avro")
    interval_in_seconds = optional(number, 300)
    size_limit_in_bytes = optional(number, 10485760)
    skip_empty_archives = optional(bool, true)
    destination = object({
      archive_name_format = string
      blob_container_name = string
      name                = string
      storage_account_id  = string
    })
  })
  default     = null
  description = <<DESCRIPTION
Defaults to `null`. Manages the Event Hub Capture feature.

- `enabled` - (Optional) - Defaults to `false`. Specifies whether Event Hub Capture is enabled.
- `encoding` - (Optional) - Defaults to `"Avro"`. Specifies the encoding format for captured events. Valid values are `"Avro"` or `"JSON"`.
- `interval_in_seconds` - (Optional) - Defaults to `300`. The frequency (in seconds) at which capture should occur. Must be between `60` and `900` seconds.
- `size_limit_in_bytes` - (Optional) - Defaults to `10485760` (10MB). The maximum size (in bytes) a capture file can reach before being written to storage. Must be between `10485760` (10MB) and `524288000` (500MB).
- `skip_empty_archives` - (Optional) - Defaults to `true`. If `true`, empty capture files will not be written to storage.

- `destination` - (Required) - Specifies the destination for captured event data:
  - `archive_name_format` - (Required) - The naming format for captured files (e.g., `"{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"`).
  - `blob_container_name` - (Required) - The name of the Azure Storage container where captured events are stored.
  - `name` - (Required) - The name of the capture destination.
  - `storage_account_id` - (Required) - The resource ID of the storage account where capture data is stored.

Example Inputs:
```hcl
capture_description = {
  enabled             = true
  encoding            = "Avro"
  interval_in_seconds = 300
  size_limit_in_bytes = 10485760
  skip_empty_archives = true
  destination = {
    archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
    blob_container_name = "eventhub-capture"
    name                = "eventhub-capture-destination"
    storage_account_id  = "/subscriptions/xxxxxx/resourceGroups/rg-name/providers/Microsoft.Storage/storageAccounts/storage-name"
  }
}
```
DESCRIPTION
}
