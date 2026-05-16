variable "route53_zone_associations" {
  type = map(object({
    zone_id    = string
    vpc_id     = string
    vpc_region = string
  }))
}
