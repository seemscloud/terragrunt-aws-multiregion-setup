include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/security_group"
}

dependency "vpc" {
  config_path = "../../../network/vpc-primary/vpc"

  mock_outputs = {
    vpc_id = "vpc-0123456789abcdef0"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  security_groups = {
    mgmt = {
      description = "mgmt"
      vpc_id      = dependency.vpc.outputs.vpc_id
      ingress = [
        {
          description = "ssh"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [get_env("MGMT_SSH_CIDR", "0.0.0.0/0")]
        }
      ]
      egress = [
        {
          description = "all"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}
