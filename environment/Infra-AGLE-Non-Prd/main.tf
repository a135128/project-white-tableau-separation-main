locals {

  location       = "australiaeast"
  resource_group = "workspace-agl-tableau-nonproduction"

  tags = {
    CostCode        = "R-PAE-000001-IT-05-05"
    Environment     = "NON-PROD"
    Business_owner  = "Ravi Kalidindi"
    Project         = "Tableau SaaS Migration"
    Technical_owner = "Ratish Sharma"
    ReadiNowId      = "NA"
    SchedExemption  = "false"
    ScheduleType    = "Non_Prod_Std"
  }

  ou_tags = {
    EnvOU = "NonProd"
    AppOU = "TableauAGL"
  }
}

module "agl_tableau_nsg" {
  source              = "terraform.automation.agl.com.au/AGL/agl-nsg/azurerm"
  name                = "agl_tableau_nsg"
  resource_group_name = local.resource_group
  location            = local.location
  tags                = local.tags
}



module "tableau_subnet" {
  source                    = "terraform.automation.agl.com.au/AGL/agl-subnet/azurerm"
  subnet_name               = "tableau_subnet"
  virtual_network_name      = "hskqscla-sehojj"
  address_prefix            = "10.231.9.128/28"
  network_security_group_id = "/subscriptions/82a17bd1-a2f3-482b-97ca-db137fa56970/resourceGroups/workspace-agl-tableau-nonproduction/providers/Microsoft.Network/networkSecurityGroups/agl_tableau_nsg"
  delegation_name           = "Microsoft.Sql/managedInstances" # Optional
  resource_group_name       = "management"
  delegation_actions        = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action", ] # Optional
  //custom_route_table        = false # Optional, false by default, can only be true for legacy network and subnets
  //route_table_id            = var.route_table_id  # optional, only required and used when custom_route_table is true and for legacy subnets
  //service_endpoints         = null

}

module "tableau_non-prod_vm_1" {
  source = "terraform.automation.agl.com.au/AGL/agl-windows-vm/azurerm"
  //version                     = "1.2.1"
  resource_group_name         = local.resource_group
  location                    = local.location
  vm_count                    = "1"
  size                        = "Standard_D8_v3"
  hostname_prefix             = "AGAZMNW"
  hostname_suffix_start_range = "0379"
  subnet_id                   = module.tableau_subnet.id
  admin_username              = "azureadmin"
  admin_password              = "T@blEau@2022"
  tags                        = local.tags
  ou_tags                     = local.ou_tags
  dsc_FunctionKey             = var.dsc_FunctionKey
  image_publisher             = "MicrosoftWindowsServer"
  image_offer                 = "WindowsServer"
  image_sku                   = "2019-Datacenter"
  //image_version               = "17763.3125.2112070401"
  timezone      = "AUS Eastern Standard Time"
  os_disk_type  = "Standard_LRS"
  os_disk_size  = "128"
  enable_backup = false
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
}

module "tableau_non-prod_vm_2" {
  source = "terraform.automation.agl.com.au/AGL/agl-windows-vm/azurerm"
  //version                     = "1.2.1"
  resource_group_name         = local.resource_group
  location                    = local.location
  vm_count                    = "1"
  size                        = "Standard_D8_v3"
  hostname_prefix             = "AGAZMNW"
  hostname_suffix_start_range = "0380"
  subnet_id                   = module.tableau_subnet.id
  admin_username              = "azureadmin"
  admin_password              = "T@blEau@2022"
  tags                        = local.tags
  ou_tags                     = local.ou_tags
  dsc_FunctionKey             = var.dsc_FunctionKey
  image_publisher             = "MicrosoftWindowsServer"
  image_offer                 = "WindowsServer"
  image_sku                   = "2019-Datacenter"
  //image_version               = "17763.3125.2112070401"
  timezone      = "AUS Eastern Standard Time"
  os_disk_type  = "Standard_LRS"
  os_disk_size  = "128"
  enable_backup = false
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
}

module "aglatableaunprdkv00" {
  source                    = "terraform.automation.agl.com.au/AGL/agl-key-vault/azurerm"
  name                      = "aglatableaunprdkv00"
  location                  = local.location
  resource_group_name       = local.resource_group
  subnet_ids                = ["/subscriptions/82a17bd1-a2f3-482b-97ca-db137fa56970/resourceGroups/management/providers/Microsoft.Network/virtualNetworks/hskqscla-sehojj/subnets/tableau_subnet/"]
  tags                      = local.tags
  enable_rbac_authorization = true
}