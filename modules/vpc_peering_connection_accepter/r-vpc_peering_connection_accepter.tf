resource "aws_vpc_peering_connection_accepter" "this" {
  vpc_peering_connection_id = var.vpc_peering_connection_accepter.vpc_peering_connection_id
  auto_accept               = true

  tags = merge(var.tags, var.vpc_peering_connection_accepter.tags)
}
