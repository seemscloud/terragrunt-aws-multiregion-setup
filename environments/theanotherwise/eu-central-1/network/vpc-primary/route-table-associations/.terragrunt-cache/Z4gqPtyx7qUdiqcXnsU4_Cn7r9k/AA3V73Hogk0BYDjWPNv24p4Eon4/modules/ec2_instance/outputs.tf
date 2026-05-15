output "instance_ids" {
  value = { for k, instance in aws_instance.this : k => instance.id }
}

output "private_ips" {
  value = { for k, instance in aws_instance.this : k => instance.private_ip }
}

output "public_ips" {
  value = { for k, instance in aws_instance.this : k => instance.public_ip }
}
