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
      "primary-eu-central-1a" = "subnet-mock-a"
      "primary-eu-central-1b" = "subnet-mock-b"
      "primary-eu-central-1c" = "subnet-mock-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  nats = {
    "primary-eu-central-1a" = {
      subnet_id = dependency.subnets.outputs.subnet_ids["primary-eu-central-1a"]
    }
    "primary-eu-central-1b" = {
      subnet_id = dependency.subnets.outputs.subnet_ids["primary-eu-central-1b"]
    }
    "primary-eu-central-1c" = {
      subnet_id = dependency.subnets.outputs.subnet_ids["primary-eu-central-1c"]
    }
  }
}
