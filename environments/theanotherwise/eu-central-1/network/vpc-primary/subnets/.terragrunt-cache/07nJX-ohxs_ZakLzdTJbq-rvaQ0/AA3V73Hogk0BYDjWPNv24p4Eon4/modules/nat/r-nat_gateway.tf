resource "aws_nat_gateway" "r-this" {
  for_each = var.v-nats

  allocation_id = aws_eip.r-this[each.key].id
  subnet_id     = each.value.subnet_id

  tags = merge(var.v-tags, each.value.tags, {
    Name = each.key
  })
}
