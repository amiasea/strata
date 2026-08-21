variable "azure_environment" {
  description = "Azure provider context published by the Landing Zone."

  type = object({
    context = string

    landing_zones = object({
      speculative = string
    })
  })
}

variable "azure_speculative_resource_group_name" {
  type = string
}

variable "tfc_azure_dynamic_credentials" {
  type = object({
    default = object({
      client_id_file_path  = string
      oidc_token_file_path = string
    })

    aliases = map(object({
      client_id_file_path  = string
      oidc_token_file_path = string
    }))
  })
}