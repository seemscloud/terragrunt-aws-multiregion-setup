output "security_group_ids" {
  value = { for k, security_group in aws_security_group.this : k => security_group.id }
}
