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