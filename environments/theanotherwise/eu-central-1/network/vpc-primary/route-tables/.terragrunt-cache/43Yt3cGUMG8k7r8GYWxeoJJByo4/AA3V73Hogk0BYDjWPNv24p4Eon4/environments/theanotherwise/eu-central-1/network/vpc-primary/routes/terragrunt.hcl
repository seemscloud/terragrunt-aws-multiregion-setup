include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/route"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    internet_gateway_id = "igw-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "route_tables" {
  config_path = "../route-tables"

  mock_outputs = {
    route_table_ids = {
      public                  = "rtb-mock-public"
      "private-eu-central-1a" = "rtb-mock-private-a"
      "private-eu-central-1b" = "rtb-mock-private-b"
      "private-eu-central-1c" = "rtb-mock-private-c"
      mgmt                    = "rtb-mock-mgmt"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "nat" {
  config_path = "../nat"

  mock_outputs = {
    nat_gateway_ids = {
      "primary-eu-central-1a" = "nat-mock-a"
      "primary-eu-central-1b" = "nat-mock-b"
      "primary-eu-central-1c" = "nat-mock-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  routes = {
    "public-default-igw" = {
      route_table_id         = dependency.route_tables.outputs.route_table_ids["public"]
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = dependency.vpc.outputs.internet_gateway_id
    }
    "private-eu-central-1a-default-nat" = {
      route_table_id         = dependency.route_tables.outputs.route_table_ids["private-eu-central-1a"]
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id         = dependency.nat.outputs.nat_gateway_ids["primary-eu-central-1a"]
    }
    "private-eu-central-1b-default-nat" = {
      route_table_id         = dependency.route_tables.outputs.route_table_ids["private-eu-central-1b"]
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id         = dependency.nat.outputs.nat_gateway_ids["primary-eu-central-1b"]
    }
    "private-eu-central-1c-default-nat" = {
      route_table_id         = dependency.route_tables.outputs.route_table_ids["private-eu-central-1c"]
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id         = dependency.nat.outputs.nat_gateway_ids["primary-eu-central-1c"]
    }
    "mgmt-default-igw" = {
      route_table_id         = dependency.route_tables.outputs.route_table_ids["mgmt"]
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = dependency.vpc.outputs.internet_gateway_id
    }
  }
}
