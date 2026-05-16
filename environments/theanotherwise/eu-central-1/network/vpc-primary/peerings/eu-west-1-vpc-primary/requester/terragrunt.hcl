include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/vpc_peering_connection"
}

dependency "eu_central_1_vpc" {
  config_path = "../../../vpc"

  mock_outputs = {
    vpc_id         = "vpc-mock-eu-central-1"
    vpc_cidr_block = "10.0.0.0/16"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "eu_west_1_vpc" {
  config_path = "../../../../../../eu-west-1/network/vpc-primary/vpc"

  mock_outputs = {
    vpc_id         = "vpc-mock-eu-west-1"
    vpc_cidr_block = "10.1.0.0/16"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  vpc_peering_connection = {
    vpc_id      = dependency.eu_central_1_vpc.outputs.vpc_id
    peer_vpc_id = dependency.eu_west_1_vpc.outputs.vpc_id
    peer_region = "eu-west-1"
    tags = {
      Name = "primary-eu-central-1-to-eu-west-1"
    }
  }
}
