locals {

  location       = "australiasoutheast"
  resource_group = "accel-workspace-tableau-production"

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
    AppOU = "TableauAccelProd"
  }
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
   virtual_network_name      = "Accel-mywjuhwn-buftnv"
   address_prefix            = "10.112.0.0/28"
   network_security_group_id = module.tableau_nsg.id
   //delegation_name           = "Microsoft.Sql/managedInstances" # Optional
   resource_group_name = "management"                                                                                                                                                                                                      # Optional Default = management
   } 


module "tableau_prod_vm_1" {
  source                      = "terraform.automation.agl.com.au/AGL/accel-windows-vm/azurerm"
  version                     = "1.3.0"
  resource_group_name         = local.resource_group
  location                    = local.location
  vm_count                    = "1"
  size                        = "Standard_D8_v3"
  hostname_prefix             = "AXAZMPW"
  hostname_suffix_start_range = "0064"
  subnet_id                   = module.tableau_subnet.id
  admin_username              = "azureadmin"
  admin_password              = "T@blEau@2022"
  tags                        = local.tags
  ou_tags                     = local.ou_tags
  dsc_FunctionKey             = var.dsc_FunctionKey
  image_publisher             = "MicrosoftWindowsServer"
  image_offer                 = "WindowsServer"
  image_sku                   = "2019-Datacenter"
  backup_policy_id            = "/subscriptions/0f08a3ca-fbc0-4058-836a-f1dfaae2acb7/resourceGroups/management/providers/Microsoft.RecoveryServices/vaults/mywjuhwnase-backuprsv/backupPolicies/protection-policy-prod-with-appdata"
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

module "tableau_prod_vm_2" {
  source                      = "terraform.automation.agl.com.au/AGL/accel-windows-vm/azurerm"
  version                     = "1.3.0"
  resource_group_name         = local.resource_group
  location                    = local.location
  vm_count                    = "1"
  size                        = "Standard_D8_v3"
  hostname_prefix             = "AXAZMPW"
  hostname_suffix_start_range = "0065"
  subnet_id                   = module.tableau_subnet.id
  admin_username              = "azureadmin"
  admin_password              = "T@blEau@2022"
  tags                        = local.tags
  ou_tags                     = local.ou_tags
  dsc_FunctionKey             = var.dsc_FunctionKey
  image_publisher             = "MicrosoftWindowsServer"
  image_offer                 = "WindowsServer"
  image_sku                   = "2019-Datacenter"
  backup_policy_id            = "/subscriptions/0f08a3ca-fbc0-4058-836a-f1dfaae2acb7/resourceGroups/management/providers/Microsoft.RecoveryServices/vaults/mywjuhwnase-backuprsv/backupPolicies/protection-policy-prod-with-appdata"
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
