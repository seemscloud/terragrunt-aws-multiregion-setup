include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/route53_zone"
}

dependency "eu_west_1_vpc" {
  config_path = "../../../network/vpc-primary/vpc"

  mock_outputs = {
    vpc_id         = "vpc-mock-eu-west-1"
    vpc_cidr_block = "10.1.0.0/16"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  route53_zone = {
    name = "eks-primary.eks.eu-west-1.aws.seems.cloud"
    vpcs = [
      {
        vpc_id     = dependency.eu_west_1_vpc.outputs.vpc_id
        vpc_region = "eu-west-1"
      },
    ]
    tags = {
      Visibility = "private"
    }
  }
}
