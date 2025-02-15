<!-- BEGIN_TF_DOCS -->
# tf-azurerm-eventhub

Module to deploy EventHub in Azure.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.9)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0, < 4.0.0)

## Resources

The following resources are used by this module:

- [azurerm_eventhub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) (resource)
- [azurerm_eventhub_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_authorization_rule) (resource)
- [azurerm_eventhub_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) (resource)
- [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint_application_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint_application_security_group_association) (resource)
- [modtm_telemetry.this](https://registry.terraform.io/providers/azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_uuid.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [modtm_module_source.this](https://registry.terraform.io/providers/azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_capacity"></a> [capacity](#input\_capacity)

Description: The capacity for the Event Hub Namespace (e.g., 1, 2, 3)

Type: `number`

### <a name="input_eventhub_name"></a> [eventhub\_name](#input\_eventhub\_name)

Description: The name of the Event Hub

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: The location/region of the Event Hub Namespace

Type: `string`

### <a name="input_message_retention"></a> [message\_retention](#input\_message\_retention)

Description: The message retention time in days for the Event Hub

Type: `number`

### <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name)

Description: The name of the Event Hub Namespace

Type: `string`

### <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count)

Description: The number of partitions for the Event Hub

Type: `number`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The name of the resource group in which the Event Hub Namespace is created

Type: `string`

### <a name="input_sku"></a> [sku](#input\_sku)

Description: The SKU of the Event Hub Namespace (e.g., Standard, Basic, Premium)

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_authorization_rules"></a> [authorization\_rules](#input\_authorization\_rules)

Description:   Defaults to `{}`. Manages a EventHub Namespace authorization Rule within a EventHub.

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

Type:

```hcl
map(object({
    name   = optional(string, null)
    listen = optional(bool, false)
    send   = optional(bool, false)
    manage = optional(bool, false)
  }))
```

Default: `{}`

### <a name="input_capture_description"></a> [capture\_description](#input\_capture\_description)

Description: Defaults to `null`. Manages the Event Hub Capture feature.

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

Type:

```hcl
object({
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
```

Default: `null`

### <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities)

Description:   Controls the Managed Identity configuration on this resource. The following properties can be specified:

  - `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
  - `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.

Type:

```hcl
object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
```

Default: `{}`

### <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints)

Description: A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private endpoint. One will be generated if not set.
- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `tags` - (Optional) A mapping of tags to assign to the private endpoint.
- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - The name of the IP configuration.
  - `private_ip_address` - The private IP address of the IP configuration.

Type:

```hcl
map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
    lock = optional(object({
      name = optional(string, null)
      kind = optional(string, "None")
    }), {})
    tags                                    = optional(map(any), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags of the resource.

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints)

Description: A map of private endpoints. The map key is the supplied input to var.private\_endpoints. The map value is the entire azurerm\_private\_endpoint resource.

### <a name="output_resource"></a> [resource](#output\_resource)

Description: "This is the full output for the resource. This is the default output for the module following AVM standards. Review the examples below for the correct output to use in your module."  
Examples:
- module.eventhub.resource.id

### <a name="output_resource_eventhubs"></a> [resource\_eventhubs](#output\_resource\_eventhubs)

Description: A map of event hubs.  The map key is the supplied input to var.event\_hubs. The map value is the entire azurerm\_event\_hubs resource.

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: This is the resource id for the EventHub resource.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
# Data Collection

The software will collect information about you and your use of the software and send it to an endpoint maintained by Wolters Kluwer. Wolters Kluwer will use this information to provide and improve our products and services. There are also some features in the software that may enable you and Wolters Kluwer to collect data from users of your applications. You can learn more about [data collection](https://confluence.wolterskluwer.io/display/DCRA/Module+Telemetry) and other helpful information within [Confluence](https://confluence.wolterskluwer.io/pages/viewpage.action?pageId=688037170&src=contextnavpagetreemode).
#
<!-- END_TF_DOCS -->