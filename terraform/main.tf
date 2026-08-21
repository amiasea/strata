module "hosting" {
    source  = "./hosting"

    azure_resource_group_name = var.azure_speculative_resource_group_name

    providers = {
      azurerm = azurerm.speculative
    }
}

# module "collective" {
#     source  = "./collective"

#     environment_id = var.collective_environment_id
# }