resource "aws_nat_gateway" "this" {
  for_each = var.nats

  allocation_id = aws_eip.this[each.key].id
  subnet_id     = each.value.subnet_id

  tags = merge(var.tags, each.value.tags, {
    Name = each.key
  })
}
