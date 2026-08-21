variable "location" {
  description = "Azure location in which the Hosting cluster is established."
  type        = string
  default     = "centralus"
}

variable "azure_resource_group_name" {
  type = string
}