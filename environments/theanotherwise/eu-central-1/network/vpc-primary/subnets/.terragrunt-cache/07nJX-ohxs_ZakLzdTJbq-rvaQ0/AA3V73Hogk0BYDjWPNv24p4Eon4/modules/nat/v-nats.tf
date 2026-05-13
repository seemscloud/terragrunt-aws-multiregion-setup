variable "v-nats" {
  type = map(object({
    subnet_id = string
    tags      = optional(map(string), {})
  }))
}
