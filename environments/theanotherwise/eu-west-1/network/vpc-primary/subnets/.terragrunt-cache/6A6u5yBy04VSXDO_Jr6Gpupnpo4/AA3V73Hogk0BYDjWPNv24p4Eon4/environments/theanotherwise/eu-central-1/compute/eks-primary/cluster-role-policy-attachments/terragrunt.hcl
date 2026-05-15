include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/iam_role_policy_attachment"
}

dependency "cluster_role" {
  config_path = "../cluster-role"

  mock_outputs = {
    role_name = "primary-eu-central-1-eks-cluster"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  iam_role_policy_attachments = {
    AmazonEKSClusterPolicy = {
      role       = dependency.cluster_role.outputs.role_name
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    }
  }
}
