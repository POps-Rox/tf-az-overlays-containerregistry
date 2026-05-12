# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azure_region_lookup" {
  source = "github.com/POps-Rox/terraform-az-overlays-azregionslookup"

  azure_region = "eastus"
}


module "acr" {
  depends_on = [
    azurerm_virtual_network.vnet
  ]
  source = "../../"
  #source  = ""github.com/POps-Rox/terraform-az-overlays-containerregistry"
  #version = "x.x.x"

  # By default, this module will not create a resource group. If you wish 
  # to use an existing resource group, provide the name of the existing resource group.
  # using `existing_resource_group_name` will ignore `create_container_registry_resource_group` and `custom_resource_group_name`.
  # The location of the group  will remain the same if you use the current resource.
  existing_resource_group_name = azurerm_resource_group.rg.name
  location                     = module.mod_azure_region_lookup.location_cli
  environment                  = "public"
  deploy_environment           = "dev"
  org_name                     = "anoa"
  workload_name                = "dev-acr"
  sku                          = "Premium"

  # NOTE: `retention_policy` and `enable_content_trust` are no-ops in azurerm 4.x —
  # the underlying ACR retention/trust policy APIs were removed by Azure and the
  # corresponding resource blocks were dropped from the provider. The module accepts
  # these inputs for backward compatibility but does not pass them to the resource.
  # Configure retention and image signing via Azure Policy / Notary v2 outside Terraform.
  retention_policy = {
    days    = 10
    enabled = true
  }

  # Content trust is a feature of the Premium service tier of Azure Container Registry.
  enable_content_trust = true

  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.azurecr.io` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  enable_private_endpoint      = true
  virtual_network_name         = azurerm_virtual_network.vnet.name
  existing_private_subnet_name = azurerm_subnet.subnet.name
  # existing_private_dns_zone     = "demo.example.com"

  # Tags for Azure Resources
  add_tags = {
    example = "basic_container_registry_with_private_endpoint"
  }
}

