output "network_acl_ids" {
  value = { for k, network_acl in aws_network_acl.this : k => network_acl.id }
}
