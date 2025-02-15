data "azurerm_client_config" "this" {
}

data "modtm_module_source" "this" {
  module_path = path.module
}

resource "random_uuid" "this" {
}
locals {
  regex_url = try(
    regex("(?i)\\.com.*wkenterprise", tostring(data.modtm_module_source.this.module_source)),
    null
  )

  # If we match the above, we attempt to extract the ref query parameter
  regex_version = try(
    regex("ref=([^&]+)", tostring(data.modtm_module_source.this.module_source)),
    null
  )

  # Determine the module_version based on whether matches are found
  module_version = local.regex_url != null ? (local.regex_version != null ? local.regex_version[0] : "non_tagged_version") : "terratest"
}

resource "modtm_telemetry" "this" {
  endpoint = "https://prod-extnaent.cdn.wkgbssvcs.com/ENT/api/v1.0/iac/telemetry"
  tags = {
    client_id       = (data.azurerm_client_config.this).client_id
    cloud_provider  = "azure"
    module_source   = (data.modtm_module_source.this).module_source
    module_name     = local.module_name
    module_version  = local.module_version
    random_id       = random_uuid.this.result
    root_resource   = azurerm_eventhub.this.id
    subscription_id = (data.azurerm_client_config.this).subscription_id
    timestamp       = timestamp()
  }
}
