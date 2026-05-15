resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.vpc_peering_connection.vpc_id
  peer_vpc_id = var.vpc_peering_connection.peer_vpc_id
  peer_region = var.vpc_peering_connection.peer_region

  tags = merge(var.tags, var.vpc_peering_connection.tags)
}
