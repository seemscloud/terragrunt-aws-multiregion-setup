variable "eks_node_groups" {
  type = map(object({
    cluster_name   = string
    node_role_arn  = string
    subnet_ids     = list(string)
    desired_size   = number
    max_size       = number
    min_size       = number
    ami_type       = optional(string)
    capacity_type  = string
    disk_size      = optional(number)
    instance_types = list(string)
    launch_template = optional(object({
      id      = string
      version = string
    }))
    name = optional(string)
    tags = optional(map(string), {})
  }))

  validation {
    condition     = alltrue([for node_group in var.eks_node_groups : length(node_group.subnet_ids) > 0])
    error_message = "Each EKS node group requires at least one subnet."
  }

  validation {
    condition     = alltrue([for node_group in var.eks_node_groups : node_group.min_size <= node_group.desired_size && node_group.desired_size <= node_group.max_size])
    error_message = "Each EKS node group requires min_size <= desired_size <= max_size."
  }

  validation {
    condition     = alltrue([for node_group in var.eks_node_groups : node_group.disk_size != null || node_group.launch_template != null])
    error_message = "Each EKS node group requires disk_size or launch_template."
  }

  validation {
    condition     = alltrue([for node_group in var.eks_node_groups : !(node_group.disk_size != null && node_group.launch_template != null)])
    error_message = "Each EKS node group must not set both disk_size and launch_template."
  }
}
