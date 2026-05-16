include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/vpc_peering_connection_accepter"
}

dependency "vpc_peering" {
  config_path = "../../../../../../eu-central-1/network/vpc-primary/peerings/eu-west-1-vpc-primary/requester"

  mock_outputs = {
    vpc_peering_connection_id = "pcx-0123456789abcdef0"
    accept_status             = "pending-acceptance"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  vpc_peering_connection_accepter = {
    vpc_peering_connection_id = dependency.vpc_peering.outputs.vpc_peering_connection_id
    tags = {
      Name = "primary-eu-central-1-to-eu-west-1"
    }
  }
}
