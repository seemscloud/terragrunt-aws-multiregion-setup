resource "aws_route53_zone_association" "this" {
  for_each = var.route53_zone_associations

  zone_id    = each.value.zone_id
  vpc_id     = each.value.vpc_id
  vpc_region = each.value.vpc_region
}
