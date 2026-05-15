resource "aws_route_table" "this" {
  for_each = var.route_tables

  vpc_id = each.value.vpc_id

  tags = merge(var.tags, each.value.tags, {
    Name = each.key
  })
}
