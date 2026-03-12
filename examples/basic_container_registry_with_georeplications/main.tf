# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azure_region_lookup" {
  source = "github.com/POps-Rox/tf-az-overlays-azregionslookup"

  azure_region = "eastus"
}


module "acr" {
  depends_on = [
    azurerm_virtual_network.vnet
  ]
  source = "../../"
  #source  = ""github.com/POps-Rox/tf-az-overlays-containerregistry"
  #version = "x.x.x"

  # By default, this module will not create a resource group. If you wish 
  # to use an existing resource group, provide the name of the existing resource group.
  # using `existing_resource_group_name` will ignore `create_container_registry_resource_group` and `custom_resource_group_name`.
  # The location of the group  will remain the same if you use the current resource.
  create_container_registry_resource_group = true
  location                                 = module.mod_azure_region_lookup.location_cli
  environment                              = "public"
  deploy_environment                       = "dev"
  org_name                                 = "anoa"
  workload_name                            = "dev-acr"
  sku                                      = "Premium"

  # The georeplications is only supported on new resources with the Premium SKU.
  # The georeplications list cannot contain the location where the Container Registry exists.
  georeplications = [
    {
      location                  = "northeurope"
      zone_redundancy_enabled   = true
      regional_endpoint_enabled = false
    },
    {
      location                  = "francecentral"
      zone_redundancy_enabled   = true
      regional_endpoint_enabled = false
    },
    {
      location                  = "uksouth"
      zone_redundancy_enabled   = true
      regional_endpoint_enabled = false
    }
  ]

  # Tags for Azure Resources
  add_tags = {
    example = "container_registry_with_georeplications"
  }
}


