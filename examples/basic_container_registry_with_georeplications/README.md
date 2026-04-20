# Azure Container Registry Overlay Terraform Module

The Azure container registry is Microsoft's hosting platform for Docker images. The private Docker container images and other relevant artifacts can be stored and managed in this private registry. Next, these images can be downloaded and utilized for container-based deployments to hosting platforms or for local use.

With optional scope-map, token, webhook, network ACLs, encryption, and private endpoints, this Terraform module aids in the creation of an Azure Container Registry.

## Use of the module to establish a basic container registry with geo-replications and optional resources

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azure_region_lookup" {
  source  = "POps-Rox/overlays-azregions-lookup/azurerm"
  version = "~> 1.0.0"

  azure_region = "eastus"
}


module "acr" {
  depends_on = [
    azurerm_virtual_network.vnet
  ]
  source  = "POps-Rox/overlays-container-registry/azurerm"
  version = "x.x.x"

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
      location                = "northeurope"
      zone_redundancy_enabled = true
    },
    {
      location                = "francecentral"
      zone_redundancy_enabled = true
    },
    {
      location                = "uksouth"
      zone_redundancy_enabled = true
    }
  ]

  # Tags for Azure Resources
  add_tags = {
    example = "container_registry_with_georeplications"
  }
}
```

## Terraform Usage

To run this example you need to execute following Terraform commands

```hcl
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when you don't need these resources.