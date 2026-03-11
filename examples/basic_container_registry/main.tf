# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azure_region_lookup" {
  source  = "github.com/POps-Rox/tf-az-overlays-azregionslookup"

  azure_region = "eastus"
}


module "acr" {
  source = "../../"
  #source  = ""github.com/POps-Rox/tf-az-overlays-containerregistry"
  #version = "x.x.x"

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_container_registry_resource_group = false." The location of the group 
  # will remain the same if you use the current resource.
  create_container_registry_resource_group = true
  location                                 = module.mod_azure_region_lookup.location_cli
  environment                              = "public"
  deploy_environment                       = "dev"
  org_name                                 = "anoa"
  workload_name                            = "dev-acr"
  sku                                      = "Standard"
  public_network_access_enabled            = true

  # Tags for Azure Resources
  add_tags = {
    foo = "bar"
  }
}

