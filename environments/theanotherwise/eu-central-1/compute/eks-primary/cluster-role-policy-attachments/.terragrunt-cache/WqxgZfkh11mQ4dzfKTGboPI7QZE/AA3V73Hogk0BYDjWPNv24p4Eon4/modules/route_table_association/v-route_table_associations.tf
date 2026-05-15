variable "route_table_associations" {
  type = map(object({
    subnet_id      = string
    route_table_id = string
  }))
}
