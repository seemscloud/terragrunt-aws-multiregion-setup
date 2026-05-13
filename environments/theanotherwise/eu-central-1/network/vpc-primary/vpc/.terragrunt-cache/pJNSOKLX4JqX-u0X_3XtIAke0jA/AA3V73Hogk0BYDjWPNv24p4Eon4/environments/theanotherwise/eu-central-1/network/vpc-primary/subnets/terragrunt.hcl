include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/subnet"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id              = "vpc-mock"
    vpc_cidr_block      = "10.0.0.0/16"
    internet_gateway_id = "igw-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  v-vpc-id = dependency.vpc.outputs.vpc_id

  v-subnets = {
    "primary-eu-central-1a" = {
      cidr_block              = "10.0.0.0/24"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = true
      tags = {
        Tier = "public"
      }
    }
    "primary-eu-central-1b" = {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "eu-central-1b"
      map_public_ip_on_launch = true
      tags = {
        Tier = "public"
      }
    }
    "primary-eu-central-1c" = {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "eu-central-1c"
      map_public_ip_on_launch = true
      tags = {
        Tier = "public"
      }
    }
  }
}
