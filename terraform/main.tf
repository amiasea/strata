module "hosting" {
    source  = "./hosting"

    environment_id = var.hosting_environment_id
}

module "collective" {
    source  = "./collective"

    environment_id = var.collective_environment_id
}