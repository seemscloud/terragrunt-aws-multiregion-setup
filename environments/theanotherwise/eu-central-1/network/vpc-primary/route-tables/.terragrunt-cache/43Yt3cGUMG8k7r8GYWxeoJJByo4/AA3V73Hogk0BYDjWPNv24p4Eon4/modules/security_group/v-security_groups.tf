variable "security_groups" {
  type = map(object({
    name        = optional(string)
    description = string
    vpc_id      = string
    ingress = optional(list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })), [])
    egress = optional(list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })), [])
    tags = optional(map(string), {})
  }))
}
