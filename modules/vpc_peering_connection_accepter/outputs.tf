output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection_accepter.this.id
}

output "accept_status" {
  value = aws_vpc_peering_connection_accepter.this.accept_status
}
