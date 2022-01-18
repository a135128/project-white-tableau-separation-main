terraform {
  required_version = ">= 0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.73.0"
    }
  }
  backend "remote" {
    hostname     = "terraform.automation.agl.com.au"
    organization = "AGL"
    workspaces {
      name = "accel-workspace-tableau-nonproduction"
    }
  }
}
