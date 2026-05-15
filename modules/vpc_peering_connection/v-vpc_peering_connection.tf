variable "vpc_peering_connection" {
  type = object({
    vpc_id      = string
    peer_vpc_id = string
    peer_region = string
    tags        = optional(map(string), {})
  })
}
