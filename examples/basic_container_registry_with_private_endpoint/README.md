# Azure Container Registry Overlay Terraform Module

The Azure container registry is Microsoft's hosting platform for Docker images. The private Docker container images and other relevant artifacts can be stored and managed in this private registry. Next, these images can be downloaded and utilized for container-based deployments to hosting platforms or for local use.

With optional scope-map, token, webhook, network ACLs, encryption, and private endpoints, this Terraform module aids in the creation of an Azure Container Registry.

## Use of the module to establish a container registry with private endpoints and optional resources

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
  existing_resource_group_name = "anoa-eus-dev-acr-dev-rg"
  location                     = module.mod_azure_region_lookup.location_cli
  environment                  = "public"
  deploy_environment           = "dev"
  org_name                     = "anoa"
  workload_name                = "dev-acr"
  sku                          = "Premium"

  # Set a retention policy with care--deleted image data is UNRECOVERABLE.
  # A retention policy for untagged manifests is currently a preview feature of Premium container registries
  # The retention policy applies only to untagged manifests with timestamps after the policy is enabled. Default is `7` days.
  retention_policy = {
    days    = 10
    enabled = true
  }

  # Content trust is a feature of the Premium service tier of Azure Container Registry.
  enable_content_trust = true

  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.azurecr.io` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  enable_private_endpoint = true  
  virtual_network_name    = azurerm_virtual_network.vnet.name
  create_private_endpoint_subnet = true
  private_subnet_address_prefix = ["10.0.100.0/24"]
  # existing_private_dns_zone     = "demo.example.com"

  # Tags for Azure Resources
  add_tags = {
    example = "basic_container_registry_with_private_endpoint"
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