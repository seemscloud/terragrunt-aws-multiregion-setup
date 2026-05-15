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
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  subnets = {
    mgmt = {
      cidr_block              = "10.0.255.240/28"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = true
      tags = {
        Tier = "mgmt"
      }
    }
    "primary-eu-central-1a" = {
      cidr_block              = "10.0.0.0/24"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = true
      name                    = "primary-eu-central-1a-pub"
      tags = {
        Tier                                         = "public"
        "kubernetes.io/cluster/primary-eu-central-1" = "shared"
        "kubernetes.io/role/elb"                     = "1"
      }
    }
    "primary-eu-central-1b" = {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "eu-central-1b"
      map_public_ip_on_launch = true
      name                    = "primary-eu-central-1b-pub"
      tags = {
        Tier                                         = "public"
        "kubernetes.io/cluster/primary-eu-central-1" = "shared"
        "kubernetes.io/role/elb"                     = "1"
      }
    }
    "primary-eu-central-1c" = {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "eu-central-1c"
      map_public_ip_on_launch = true
      name                    = "primary-eu-central-1c-pub"
      tags = {
        Tier                                         = "public"
        "kubernetes.io/cluster/primary-eu-central-1" = "shared"
        "kubernetes.io/role/elb"                     = "1"
      }
    }
    "private-eu-central-1a" = {
      cidr_block              = "10.0.10.0/24"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = false
      name                    = "primary-eu-central-1a-prv"
      tags = {
        Tier                                         = "private"
        "kubernetes.io/cluster/primary-eu-central-1" = "shared"
        "kubernetes.io/role/internal-elb"            = "1"
      }
    }
    "private-eu-central-1b" = {
      cidr_block              = "10.0.11.0/24"
      availability_zone       = "eu-central-1b"
      map_public_ip_on_launch = false
      name                    = "primary-eu-central-1b-prv"
      tags = {
        Tier                                         = "private"
        "kubernetes.io/cluster/primary-eu-central-1" = "shared"
        "kubernetes.io/role/internal-elb"            = "1"
      }
    }
    "private-eu-central-1c" = {
      cidr_block              = "10.0.12.0/24"
      availability_zone       = "eu-central-1c"
      map_public_ip_on_launch = false
      name                    = "primary-eu-central-1c-prv"
      tags = {
        Tier                                         = "private"
        "kubernetes.io/cluster/primary-eu-central-1" = "shared"
        "kubernetes.io/role/internal-elb"            = "1"
      }
    }
  }
}
