resource "aws_subnet" "r-this" {
  for_each = var.v-subnets

  vpc_id                  = var.v-vpc-id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(var.v-tags, each.value.tags, {
    Name = each.key
  })
}
