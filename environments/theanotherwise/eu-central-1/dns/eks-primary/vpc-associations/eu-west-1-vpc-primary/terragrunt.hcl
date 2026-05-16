include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/route53_zone_association"
}

dependency "private_zone" {
  config_path = "../../private-zone"

  mock_outputs = {
    zone_id = "Z00000000000000000000"
    name    = "eks-primary.eks.eu-central-1.aws.seems.cloud"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "vpc" {
  config_path = "../../../../../eu-west-1/network/vpc-primary/vpc"

  mock_outputs = {
    vpc_id         = "vpc-mock-eu-west-1"
    vpc_cidr_block = "10.1.0.0/16"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  route53_zone_associations = {
    eu_west_1_vpc_primary = {
      zone_id    = dependency.private_zone.outputs.zone_id
      vpc_id     = dependency.vpc.outputs.vpc_id
      vpc_region = "eu-west-1"
    }
  }
}
