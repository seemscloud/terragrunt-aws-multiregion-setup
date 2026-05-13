output "vpc_id" {
  value = aws_vpc.r-this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.r-this.cidr_block
}

output "internet_gateway_id" {
  value = try(aws_internet_gateway.r-this[0].id, null)
}
