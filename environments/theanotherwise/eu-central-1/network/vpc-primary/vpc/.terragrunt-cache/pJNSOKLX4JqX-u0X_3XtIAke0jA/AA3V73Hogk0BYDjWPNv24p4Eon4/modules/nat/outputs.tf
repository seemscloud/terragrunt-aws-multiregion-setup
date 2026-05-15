output "eip_ids" {
  value = { for k, e in aws_eip.this : k => e.id }
}

output "eip_public_ips" {
  value = { for k, e in aws_eip.this : k => e.public_ip }
}

output "nat_gateway_ids" {
  value = { for k, n in aws_nat_gateway.this : k => n.id }
}
