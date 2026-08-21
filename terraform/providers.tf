terraform {
  required_version = ">= 1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.1.0"
    }
  }
}

provider "azurerm" {
  alias = "speculative"

  tenant_id       = var.azure_environment.context
  subscription_id = var.azure_environment.landing_zones.speculative

  use_oidc              = true
  client_id_file_path   = var.tfc_azure_dynamic_credentials.aliases["SPECULATIVE"].client_id_file_path
  oidc_token_file_path  = var.tfc_azure_dynamic_credentials.aliases["SPECULATIVE"].oidc_token_file_path

  features {}
}