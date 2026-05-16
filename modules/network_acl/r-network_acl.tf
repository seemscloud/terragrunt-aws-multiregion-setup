resource "aws_network_acl" "this" {
  for_each = var.network_acls

  vpc_id     = each.value.vpc_id
  subnet_ids = each.value.subnet_ids

  dynamic "ingress" {
    for_each = each.value.ingress

    content {
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      protocol   = ingress.value.protocol
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
      cidr_block = ingress.value.cidr_block
    }
  }

  dynamic "egress" {
    for_each = each.value.egress

    content {
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      protocol   = egress.value.protocol
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
      cidr_block = egress.value.cidr_block
    }
  }

  tags = merge(var.tags, each.value.tags, {
    Name = coalesce(each.value.name, each.key)
  })
}
