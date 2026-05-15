variable "nats" {
  type = map(object({
    subnet_id = string
    name      = optional(string)
    tags      = optional(map(string), {})
  }))
}
