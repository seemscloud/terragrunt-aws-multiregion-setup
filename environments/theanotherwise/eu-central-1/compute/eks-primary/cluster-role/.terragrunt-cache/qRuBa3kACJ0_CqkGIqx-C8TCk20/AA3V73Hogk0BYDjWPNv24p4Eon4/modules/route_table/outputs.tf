output "route_table_ids" {
  value = { for k, r in aws_route_table.this : k => r.id }
}
