include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/route_table"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = "vpc-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  route_tables = {
    public = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        Tier = "public"
      }
    }
    "private-eu-central-1a" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-central-1a"
        Tier             = "private"
      }
    }
    "private-eu-central-1b" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-central-1b"
        Tier             = "private"
      }
    }
    "private-eu-central-1c" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-central-1c"
        Tier             = "private"
      }
    }
    "lb-eu-central-1a" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-central-1a"
        Tier             = "lb"
      }
    }
    "lb-eu-central-1b" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-central-1b"
        Tier             = "lb"
      }
    }
    "lb-eu-central-1c" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-central-1c"
        Tier             = "lb"
      }
    }
    mgmt = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        Tier = "mgmt"
      }
    }
  }
}
