variable "vpc_peering_connection_accepter" {
  type = object({
    vpc_peering_connection_id = string
    tags                      = optional(map(string), {})
  })
}
