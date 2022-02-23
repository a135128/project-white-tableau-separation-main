provider "azurerm" {
  //version                    = "~>2.0"
  //version                    = "~> 2.72"
  subscription_id = var.azure_subscription_id
  tenant_id       = var.ARM_TENANT_ID
  client_id       = var.ARM_CLIENT_ID
  features {}
  skip_provider_registration = true
}

provider "null" {
  //version = "~> 2.1"
}

provider "random" {
  //version = "~> 2.2"
}

provider "template" {
  //version = "~> 2.1"
}

provider "local" {
  //version = "~> 1.4"
}