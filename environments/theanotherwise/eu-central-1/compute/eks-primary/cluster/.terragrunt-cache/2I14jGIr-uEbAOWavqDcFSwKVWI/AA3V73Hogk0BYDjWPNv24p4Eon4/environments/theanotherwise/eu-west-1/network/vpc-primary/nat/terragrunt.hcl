include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/nat"
}

dependency "subnets" {
  config_path = "../subnets"

  mock_outputs = {
    subnet_ids = {
      mgmt                 = "subnet-mock-mgmt"
      "primary-eu-west-1a" = "subnet-mock-a"
      "primary-eu-west-1b" = "subnet-mock-b"
      "primary-eu-west-1c" = "subnet-mock-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  nats = {
    "primary-eu-west-1a" = {
      subnet_id = dependency.subnets.outputs.subnet_ids["primary-eu-west-1a"]
      name      = "primary-eu-west-1a-pub"
    }
    "primary-eu-west-1b" = {
      subnet_id = dependency.subnets.outputs.subnet_ids["primary-eu-west-1b"]
      name      = "primary-eu-west-1b-pub"
    }
    "primary-eu-west-1c" = {
      subnet_id = dependency.subnets.outputs.subnet_ids["primary-eu-west-1c"]
      name      = "primary-eu-west-1c-pub"
    }
  }
}
