variable "routes" {
  type = map(object({
    route_table_id         = string
    destination_cidr_block = string
    gateway_id             = optional(string)
    nat_gateway_id         = optional(string)
  }))

  validation {
    condition = alltrue([
      for route in values(var.routes) : (route.gateway_id != null ? 1 : 0) + (route.nat_gateway_id != null ? 1 : 0) == 1
    ])
    error_message = "Each route requires exactly one target."
  }
}
