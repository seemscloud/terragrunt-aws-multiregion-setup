output "subnet_ids" {
  value = { for k, s in aws_subnet.r-this : k => s.id }
}
