locals {

  location       = "australiaeast"
  resource_group = "accel-workspace-tableau-nonproduction"

  tags = {
    CostCode        = "R-PAE-000001-IT-05-05"
    Environment     = "NON-PROD"
    Business_owner  = "Ravi Kalidindi"
    Project         = "Tableau SaaS Migration"
    Technical_owner = "Ratish Sharma"
    ReadiNowId      = "NA"
  }

  ou_tags = {
    EnvOU = "NonProd"
    AppOU = "TableauAccel"
  }
}

data "azurerm_resource_group" "rg" {
  name = local.resource_group
}

data "azurerm_resource_group" "vnet_rg" {
  name = var.vnet_resource_group
}

data "azurerm_virtual_network" "tableau_accel" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group
}



//nsg for Tableau VM's
module "tableau_nsg" {
  source              = "terraform.automation.agl.com.au/AGL/accel-nsg/azurerm"
  name                = "tableau_nsg"
  resource_group_name = local.resource_group
  location            = local.location
  tags                = local.tags
}


module "tableau_subnet" {
  source                    = "terraform.automation.agl.com.au/AGL/accel-subnet/azurerm"
  subnet_name               = "tableau_subnet"
  virtual_network_name      = "Accel-eenhquxj-zocfyh"
  address_prefix            = "10.112.199.0/28"
  network_security_group_id = "/subscriptions/a1ea37a3-7d02-4b09-933e-ccd903dec949/resourceGroups/accel-workspace-tableau-nonproduction/providers/Microsoft.Network/networkSecurityGroups/tableau_nsg"
  //delegation_name           = "Microsoft.Sql/managedInstances" # Optional
  resource_group_name = "management"                                                                                                                                                                                                      # Optional Default = management
  delegation_actions  = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"] # Optional
  service_endpoints   = null

}
//VM creation with older VM module

/* module "tableau_non-prod_vm_1" {
  source                      = "terraform.automation.agl.com.au/AGL/accel-windows-vm/azurerm"
  version                     = "1.1.3"
  resource_group_name         = local.resource_group
  location                    = local.location
  vm_count                    = "1"
  size                        = "Standard_D8_v3"
  hostname_prefix             = "AXAZSNW"
  hostname_suffix_start_range = "0068"
  subnet_id                   = module.tableau_subnet.id
  admin_username              = "azureadmin"
  admin_password              = "T@blEau@2022"
  tags                        = local.tags
  ou_tags                     = local.ou_tags
  dsc_FunctionKey             = var.dsc_FunctionKey
  image_publisher             = "MicrosoftWindowsServer"
  image_offer                 = "WindowsServer"
  image_sku                   = "2019-Datacenter"
  image_version               = "17763.3125.2112070401"
  timezone                    = "AUS Eastern Standard Time"
  os_disk_type                = "Standard_LRS"
  os_disk_size                = "128"
  enable_backup               = false
  //private_ip_address_allocation = "static"
  //private_ip_address            = "10.9.10.28"
  data_disks = [
    [
      {
        disk_size_gb              = 256
        storage_account_type      = "Standard_LRS"
        caching                   = "None"
        create_option             = "Empty"
        source_resource_id        = ""
        write_accelerator_enabled = false
      }
    ]
  ]
} */


// VM creation with latest VM module

module "tableau_non-prod_vm_1" {
  source                        = "terraform.automation.agl.com.au/AGL/accel-windows-vm/azurerm"
  resource_group_name           = local.resource_group
  location                      = local.location
  size                          = "Standard_D8_v3"
  hostname_prefix               = "AXAZSNW"
  hostname_suffix_start_range   = "0068"
  vm_count                      = "1"
  network_interfaces = [
    {
      subnet_id                     = module.tableau_subnet.id,
      private_ip_address_allocation = "dynamic",
      private_ip_address            = null,
      enable_accelerated_networking = false
    }
  ]
  admin_username                = "azureadmin"
  admin_password                = "T@blEau@2022"
  //availability_set_id           = "xxxx-xxxx-xx-xxxxxx"
  tags                          = local.tags
  ou_tags                       = local.ou_tags
  dsc_FunctionKey               = var.dsc_FunctionKey
  log_to_scom                   = false
  //log_to_loganalytics           = true
  //loganalytics_workspace_id     = var.my_la_id
  //loganalytics_workspace_key    = var.my_la_key
  disk_alloc_unit_size          = 65536
  //identity                      = [{type = "SystemAssigned"}]
  data_disks = [
    [
      {
        disk_size_gb              = 256
        storage_account_type      = "Standard_LRS"
        caching                   = "ReadOnly"
        create_option             = "Empty"
        source_resource_id        = ""
        write_accelerator_enabled = false
      },
    ]
  ]
}