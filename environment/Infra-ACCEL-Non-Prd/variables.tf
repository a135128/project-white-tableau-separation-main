variable "ARM_CLIENT_ID" {
  type        = string
  description = "ARM_CLIENT_ID from environment variables"
}

variable "azure_subscription_id" {
  type        = string
  description = "subscription_id from workspace variables"
}

variable "ARM_TENANT_ID" {
  type        = string
  description = "ARM_TENANT_ID from environment variables"
}

/* variable "azure_resource_group" {
  type        = string
  description = "Azure resource group in which to deploy resources."
} */

/* variable "business_owner" {
  type        = string
  description = "Value for tag BusinessOwner"
}

variable "cost_code" {
  type        = string
  description = "Value for tag CostCode"
} */

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network to be used for resources."
}

variable "vnet_resource_group" {
  type        = string
  description = "Resource group name containing the Virtual Network for resources."
}


/* variable "project" {
  type        = string
  description = "Value for tag Project"
} */

variable "ansible_vault_key" {
  description = "The variable has to be defined in TFE as designed, The Ansible Vault key used to encrypt the AD domain account"
}

/* variable "location" {
  description = "Azure data center location in which the VM should be created"
}
 */
/* variable "data_stack_subnet_id" {
  description = "APP Subnet ID"
}
 */
variable "dsc_FunctionKey" {
  description = "Variable for the use of DSC Environment Variable in the workspace"
}