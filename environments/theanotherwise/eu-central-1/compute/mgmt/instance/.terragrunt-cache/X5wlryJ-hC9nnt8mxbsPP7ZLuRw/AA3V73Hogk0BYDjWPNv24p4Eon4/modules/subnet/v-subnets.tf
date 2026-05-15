variable "subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = optional(bool, false)
    name                    = optional(string)
    tags                    = optional(map(string), {})
  }))
}
