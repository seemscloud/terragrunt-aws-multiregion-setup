variable "network_acls" {
  type = map(object({
    name       = optional(string)
    vpc_id     = string
    subnet_ids = list(string)
    ingress = list(object({
      rule_no    = number
      action     = string
      protocol   = string
      from_port  = number
      to_port    = number
      cidr_block = string
    }))
    egress = list(object({
      rule_no    = number
      action     = string
      protocol   = string
      from_port  = number
      to_port    = number
      cidr_block = string
    }))
    tags = optional(map(string), {})
  }))
}
