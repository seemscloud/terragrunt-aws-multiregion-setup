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
    vpc_cidr_block      = "10.1.0.0/16"
    internet_gateway_id = "igw-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  v-vpc-id = dependency.vpc.outputs.vpc_id

  v-subnets = {
    "primary-eu-west-1a" = {
      cidr_block              = "10.1.0.0/24"
      availability_zone       = "eu-west-1a"
      map_public_ip_on_launch = true
      tags = {
        Tier = "public"
      }
    }
    "primary-eu-west-1b" = {
      cidr_block              = "10.1.1.0/24"
      availability_zone       = "eu-west-1b"
      map_public_ip_on_launch = true
      tags = {
        Tier = "public"
      }
    }
    "primary-eu-west-1c" = {
      cidr_block              = "10.1.2.0/24"
      availability_zone       = "eu-west-1c"
      map_public_ip_on_launch = true
      tags = {
        Tier = "public"
      }
    }
  }
}
