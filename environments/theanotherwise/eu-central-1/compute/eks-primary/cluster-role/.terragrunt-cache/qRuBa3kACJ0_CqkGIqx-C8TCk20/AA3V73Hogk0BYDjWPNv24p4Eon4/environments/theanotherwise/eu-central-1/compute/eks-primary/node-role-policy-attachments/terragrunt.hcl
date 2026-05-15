include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/iam_role_policy_attachment"
}

dependency "node_role" {
  config_path = "../node-role"

  mock_outputs = {
    role_name = "primary-eu-central-1-eks-node"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  iam_role_policy_attachments = {
    AmazonEKSWorkerNodePolicy = {
      role       = dependency.node_role.outputs.role_name
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    }
    AmazonEC2ContainerRegistryPullOnly = {
      role       = dependency.node_role.outputs.role_name
      policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
    }
    AmazonEKS_CNI_Policy = {
      role       = dependency.node_role.outputs.role_name
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    }
  }
}
