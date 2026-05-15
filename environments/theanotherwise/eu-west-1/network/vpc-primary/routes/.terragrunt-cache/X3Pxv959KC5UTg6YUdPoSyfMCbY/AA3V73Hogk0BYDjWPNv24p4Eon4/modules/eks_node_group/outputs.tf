output "node_group_arns" {
  value = { for k, node_group in aws_eks_node_group.this : k => node_group.arn }
}

output "node_group_names" {
  value = { for k, node_group in aws_eks_node_group.this : k => node_group.node_group_name }
}
