data "popsrox_utils_resource_name" "acr" {
  name          = var.workload_name
  resource_type = "azurerm_container_registry"
  prefixes      = [var.org_name, module.mod_azure_region_lookup.location_short]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "acr"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}
