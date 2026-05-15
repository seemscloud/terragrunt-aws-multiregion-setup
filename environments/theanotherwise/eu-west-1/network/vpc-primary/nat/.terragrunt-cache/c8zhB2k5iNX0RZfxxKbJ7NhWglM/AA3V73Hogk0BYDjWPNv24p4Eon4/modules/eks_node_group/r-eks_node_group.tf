moved {
  from = aws_eks_node_group.r-this
  to   = aws_eks_node_group.this
}

resource "aws_eks_node_group" "this" {
  for_each = var.eks_node_groups

  cluster_name    = each.value.cluster_name
  node_group_name = coalesce(each.value.name, each.key)
  node_role_arn   = each.value.node_role_arn
  subnet_ids      = each.value.subnet_ids
  ami_type        = each.value.ami_type
  capacity_type   = each.value.capacity_type
  disk_size       = each.value.launch_template == null ? each.value.disk_size : null
  instance_types  = each.value.instance_types

  dynamic "launch_template" {
    for_each = each.value.launch_template == null ? [] : [each.value.launch_template]

    content {
      id      = launch_template.value.id
      version = launch_template.value.version
    }
  }

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  tags = merge(var.tags, each.value.tags)
}
