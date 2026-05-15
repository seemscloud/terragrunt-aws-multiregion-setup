output "launch_template_ids" {
  value = { for k, launch_template in aws_launch_template.this : k => launch_template.id }
}

output "launch_template_latest_versions" {
  value = { for k, launch_template in aws_launch_template.this : k => tostring(launch_template.latest_version) }
}
