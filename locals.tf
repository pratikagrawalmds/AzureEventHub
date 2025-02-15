locals {
  module_name = "tf_azurerm_eventhub"
  tags = {
    wk_iac_framework = "${local.module_name}-${local.module_version}",
    wk_resource_name = "${var.eventhub_name}"
  }
  private_endpoint_application_security_group_associations = { for assoc in flatten([
    for pe_k, pe_v in var.private_endpoints : [
      for asg_k, asg_v in pe_v.application_security_group_associations : {
        asg_key         = asg_k
        pe_key          = pe_k
        asg_resource_id = asg_v
      }
    ]
  ]) : "${assoc.pe_key}-${assoc.asg_key}" => assoc }
}