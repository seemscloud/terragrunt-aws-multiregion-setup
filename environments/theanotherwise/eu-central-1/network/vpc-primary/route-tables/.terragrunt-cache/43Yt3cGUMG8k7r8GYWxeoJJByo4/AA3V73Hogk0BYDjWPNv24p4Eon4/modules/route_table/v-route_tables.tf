variable "route_tables" {
  type = map(object({
    vpc_id = string
    tags   = optional(map(string), {})
  }))
}
