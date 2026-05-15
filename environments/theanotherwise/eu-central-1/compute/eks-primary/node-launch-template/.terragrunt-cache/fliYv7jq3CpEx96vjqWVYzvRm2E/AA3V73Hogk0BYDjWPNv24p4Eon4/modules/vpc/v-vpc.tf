variable "vpc" {
  type = object({
    name                 = string
    cidr_block           = string
    enable_dns_hostnames = optional(bool, true)
    enable_dns_support   = optional(bool, true)
  })

  validation {
    condition     = length(var.vpc.name) > 0
    error_message = "VPC name is required."
  }
}
