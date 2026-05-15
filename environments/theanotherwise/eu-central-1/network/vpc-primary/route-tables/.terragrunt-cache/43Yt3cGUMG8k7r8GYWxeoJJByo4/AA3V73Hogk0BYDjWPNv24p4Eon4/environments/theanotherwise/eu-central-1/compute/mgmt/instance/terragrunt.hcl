include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/ec2_instance"
}

dependency "subnets" {
  config_path = "../../../network/vpc-primary/subnets"

  mock_outputs = {
    subnet_ids = {
      mgmt = "subnet-0123456789abcdef0"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "security_group" {
  config_path = "../security-group"

  mock_outputs = {
    security_group_ids = {
      mgmt = "sg-0123456789abcdef0"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependencies {
  paths = [
    "../../../network/vpc-primary/route-table-associations",
    "../../../network/vpc-primary/routes",
  ]
}

inputs = {
  ec2_instances = {
    mgmt = {
      ami_ssm_parameter_name      = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
      instance_type               = "t3.small"
      subnet_id                   = dependency.subnets.outputs.subnet_ids["mgmt"]
      associate_public_ip_address = true
      vpc_security_group_ids      = [dependency.security_group.outputs.security_group_ids["mgmt"]]
      user_data = join("\n", [
        "#cloud-config",
        yamlencode({
          users = [
            "default",
            {
              name                = "taw"
              groups              = ["sudo"]
              shell               = "/bin/bash"
              sudo                = "ALL=(ALL) NOPASSWD:ALL"
              ssh_authorized_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYA8CkWVmfIBw8+H+0xR6J0e6kzGsCgXOa4LqdlGfop"]
            }
          ]
        })
      ])
      root_block_device = {
        volume_size = 20
        volume_type = "gp3"
      }
      tags = {
        Tier = "mgmt"
      }
    }
  }
}
