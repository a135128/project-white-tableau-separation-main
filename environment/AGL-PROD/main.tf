locals {

  location       = "australiasoutheast"
  resource_group = "workspace-agl-tableau-production"

  tags = {
    CostCode        = "R-PAE-000001-IT-05-05"
    Environment     = "PROD"
    Business_owner  = "Ravi Kalidindi"
    Project         = "Tableau SaaS Migration"
    Technical_owner = "Ratish Sharma"
    ReadiNowId      = "NA"
    //SchedExemption  = "false"
    //ScheduleType    = "Non_Prod_Std"
  }

  ou_tags = {
    EnvOU = "Prod"
    AppOU = "TableauAGLProd"
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
  virtual_network_name      = "jkpocwhs-piqqez"
  address_prefix            = "10.230.222.128/28"
  network_security_group_id = module.agl_tableau_nsg.id
  delegation_name           = "Microsoft.Sql/managedInstances" # Optional
  resource_group_name       = "management"
  delegation_actions        = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action", ] # Optional
}

// Tableau VM1
module "tableau_prod_vm_1" {
  source                      = "terraform.automation.agl.com.au/AGL/agl-windows-vm/azurerm"
  version                     = "8.1.2"
  resource_group_name         = local.resource_group
  location                    = local.location
  vm_count                    = "1"
  size                        = "Standard_D8_v3"
  hostname_prefix             = "AGAZMP"
  hostname_suffix_start_range = "0862"
  subnet_id                   = module.tableau_subnet.id
  admin_username              = "azureadmin"
  admin_password              = "T@blEau@2022"
  tags                        = local.tags
  ou_tags                     = local.ou_tags
  dsc_FunctionKey             = var.dsc_FunctionKey
  image_publisher             = "MicrosoftWindowsServer"
  image_offer                 = "WindowsServer"
  image_sku                   = "2019-Datacenter"
  backup_policy_id            = "/subscriptions/3ed2fce0-645b-40c0-aefb-d5a838a69457/resourceGroups/management/providers/Microsoft.RecoveryServices/vaults/jkpocwhsase-backuprsv/backupPolicies/protection-policy-prod-with-appdata"
  recovery_vault_name         = var.recovery_vault_name
  timezone                    = "AUS Eastern Standard Time"
  os_disk_type                = "Standard_LRS"
  os_disk_size                = "128"
  enable_backup               = true
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

//Tableau VM2
module "tableau_prod_vm_2" {
  source                      = "terraform.automation.agl.com.au/AGL/agl-windows-vm/azurerm"
  version                     = "8.1.2"
  resource_group_name         = local.resource_group
  location                    = local.location
  vm_count                    = "1"
  size                        = "Standard_D8_v3"
  hostname_prefix             = "AGAZMP"
  hostname_suffix_start_range = "0863"
  subnet_id                   = module.tableau_subnet.id
  admin_username              = "azureadmin"
  admin_password              = "T@blEau@2022"
  tags                        = local.tags
  ou_tags                     = local.ou_tags
  dsc_FunctionKey             = var.dsc_FunctionKey
  image_publisher             = "MicrosoftWindowsServer"
  image_offer                 = "WindowsServer"
  image_sku                   = "2019-Datacenter"
  backup_policy_id            = "/subscriptions/3ed2fce0-645b-40c0-aefb-d5a838a69457/resourceGroups/management/providers/Microsoft.RecoveryServices/vaults/jkpocwhsase-backuprsv/backupPolicies/protection-policy-prod-with-appdata"
  recovery_vault_name         = var.recovery_vault_name
  timezone                    = "AUS Eastern Standard Time"
  os_disk_type                = "Standard_LRS"
  os_disk_size                = "128"
  enable_backup               = true
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