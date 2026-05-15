include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/eks_cluster"
}

dependency "cluster_role" {
  config_path = "../cluster-role"

  mock_outputs = {
    role_arn  = "arn:aws:iam::674403012652:role/primary-eu-central-1-eks-cluster"
    role_name = "primary-eu-central-1-eks-cluster"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "subnets" {
  config_path = "../../../network/vpc-primary/subnets"

  mock_outputs = {
    subnet_ids = {
      "private-eu-central-1a" = "subnet-mock-private-a"
      "private-eu-central-1b" = "subnet-mock-private-b"
      "private-eu-central-1c" = "subnet-mock-private-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependencies {
  paths = ["../cluster-role-policy-attachments"]
}

inputs = {
  eks_cluster = {
    name     = "primary-eu-central-1"
    role_arn = dependency.cluster_role.outputs.role_arn
    subnet_ids = [
      dependency.subnets.outputs.subnet_ids["private-eu-central-1a"],
      dependency.subnets.outputs.subnet_ids["private-eu-central-1b"],
      dependency.subnets.outputs.subnet_ids["private-eu-central-1c"],
    ]
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
    endpoint_private_access                     = true
    endpoint_public_access                      = true
    public_access_cidrs                         = [get_env("EKS_PUBLIC_ACCESS_CIDR", "0.0.0.0/0")]
  }
}
