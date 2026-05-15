moved {
  from = aws_eks_cluster.r-this
  to   = aws_eks_cluster.this
}

resource "aws_eks_cluster" "this" {
  name     = var.eks_cluster.name
  role_arn = var.eks_cluster.role_arn

  access_config {
    authentication_mode                         = var.eks_cluster.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.eks_cluster.bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {
    endpoint_private_access = var.eks_cluster.endpoint_private_access
    endpoint_public_access  = var.eks_cluster.endpoint_public_access
    public_access_cidrs     = var.eks_cluster.public_access_cidrs
    subnet_ids              = var.eks_cluster.subnet_ids
  }

  tags = merge(var.tags, var.eks_cluster.tags)
}
