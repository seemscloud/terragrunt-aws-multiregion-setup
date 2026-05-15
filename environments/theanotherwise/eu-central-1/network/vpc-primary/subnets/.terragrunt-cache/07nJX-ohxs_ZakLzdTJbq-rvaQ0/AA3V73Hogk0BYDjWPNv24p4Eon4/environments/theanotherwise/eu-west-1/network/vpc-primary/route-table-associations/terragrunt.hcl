include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/route_table_association"
}

dependency "subnets" {
  config_path = "../subnets"

  mock_outputs = {
    subnet_ids = {
      mgmt                 = "subnet-mock-mgmt"
      "primary-eu-west-1a" = "subnet-mock-public-a"
      "primary-eu-west-1b" = "subnet-mock-public-b"
      "primary-eu-west-1c" = "subnet-mock-public-c"
      "private-eu-west-1a" = "subnet-mock-private-a"
      "private-eu-west-1b" = "subnet-mock-private-b"
      "private-eu-west-1c" = "subnet-mock-private-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "route_tables" {
  config_path = "../route-tables"

  mock_outputs = {
    route_table_ids = {
      public               = "rtb-mock-public"
      "private-eu-west-1a" = "rtb-mock-private-a"
      "private-eu-west-1b" = "rtb-mock-private-b"
      "private-eu-west-1c" = "rtb-mock-private-c"
      mgmt                 = "rtb-mock-mgmt"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  route_table_associations = {
    "public-eu-west-1a" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["primary-eu-west-1a"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["public"]
    }
    "public-eu-west-1b" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["primary-eu-west-1b"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["public"]
    }
    "public-eu-west-1c" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["primary-eu-west-1c"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["public"]
    }
    "private-eu-west-1a" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["private-eu-west-1a"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["private-eu-west-1a"]
    }
    "private-eu-west-1b" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["private-eu-west-1b"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["private-eu-west-1b"]
    }
    "private-eu-west-1c" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["private-eu-west-1c"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["private-eu-west-1c"]
    }
    mgmt = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["mgmt"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["mgmt"]
    }
  }
}
