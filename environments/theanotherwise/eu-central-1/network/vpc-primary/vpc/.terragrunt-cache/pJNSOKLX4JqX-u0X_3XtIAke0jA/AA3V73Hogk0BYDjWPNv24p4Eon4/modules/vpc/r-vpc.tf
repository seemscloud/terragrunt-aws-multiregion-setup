resource "aws_vpc" "r-this" {
  cidr_block           = var.v-vpc.cidr_block
  enable_dns_hostnames = var.v-vpc.enable_dns_hostnames
  enable_dns_support   = var.v-vpc.enable_dns_support

  tags = merge(var.v-tags, {
    Name = var.v-vpc.name
  })
}
