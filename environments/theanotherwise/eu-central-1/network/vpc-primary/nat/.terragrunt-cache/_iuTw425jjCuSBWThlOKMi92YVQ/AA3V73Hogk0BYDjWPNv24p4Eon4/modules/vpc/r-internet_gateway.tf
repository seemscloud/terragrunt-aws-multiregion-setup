resource "aws_internet_gateway" "r-this" {
  count = var.v-internet-gateway-enabled ? 1 : 0

  vpc_id = aws_vpc.r-this.id

  tags = merge(var.v-tags, {
    Name = "${var.v-vpc.name}-igw"
  })
}
