variable "eks_cluster" {
  type = object({
    name                                        = string
    role_arn                                    = string
    subnet_ids                                  = list(string)
    authentication_mode                         = optional(string, "API_AND_CONFIG_MAP")
    bootstrap_cluster_creator_admin_permissions = optional(bool, true)
    endpoint_private_access                     = optional(bool, false)
    endpoint_public_access                      = optional(bool, true)
    public_access_cidrs                         = optional(list(string), ["0.0.0.0/0"])
    tags                                        = optional(map(string), {})
  })

  validation {
    condition     = length(var.eks_cluster.name) > 0
    error_message = "EKS cluster name is required."
  }

  validation {
    condition     = length(var.eks_cluster.role_arn) > 0
    error_message = "EKS cluster role ARN is required."
  }

  validation {
    condition     = length(var.eks_cluster.subnet_ids) >= 2
    error_message = "EKS cluster requires at least two subnets."
  }

  validation {
    condition     = contains(["CONFIG_MAP", "API", "API_AND_CONFIG_MAP"], var.eks_cluster.authentication_mode)
    error_message = "EKS cluster authentication mode must be CONFIG_MAP, API, or API_AND_CONFIG_MAP."
  }

  validation {
    condition     = var.eks_cluster.endpoint_private_access || var.eks_cluster.endpoint_public_access
    error_message = "EKS cluster requires private or public endpoint access."
  }
}
