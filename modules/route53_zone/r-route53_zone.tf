resource "aws_route53_zone" "this" {
  name = var.route53_zone.name

  dynamic "vpc" {
    for_each = var.route53_zone.vpcs

    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.vpc_region
    }
  }

  tags = merge(var.tags, var.route53_zone.tags)

  lifecycle {
    ignore_changes = [vpc]
  }
}
