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
      mgmt                    = "subnet-mock-mgmt"
      "primary-eu-central-1a" = "subnet-mock-public-a"
      "primary-eu-central-1b" = "subnet-mock-public-b"
      "primary-eu-central-1c" = "subnet-mock-public-c"
      "private-eu-central-1a" = "subnet-mock-private-a"
      "private-eu-central-1b" = "subnet-mock-private-b"
      "private-eu-central-1c" = "subnet-mock-private-c"
      "lb-eu-central-1a"      = "subnet-mock-lb-a"
      "lb-eu-central-1b"      = "subnet-mock-lb-b"
      "lb-eu-central-1c"      = "subnet-mock-lb-c"
    }
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
      "lb-eu-central-1a"      = "rtb-mock-lb-a"
      "lb-eu-central-1b"      = "rtb-mock-lb-b"
      "lb-eu-central-1c"      = "rtb-mock-lb-c"
      mgmt                    = "rtb-mock-mgmt"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  route_table_associations = {
    "public-eu-central-1a" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["primary-eu-central-1a"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["public"]
    }
    "public-eu-central-1b" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["primary-eu-central-1b"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["public"]
    }
    "public-eu-central-1c" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["primary-eu-central-1c"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["public"]
    }
    "private-eu-central-1a" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["private-eu-central-1a"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["private-eu-central-1a"]
    }
    "private-eu-central-1b" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["private-eu-central-1b"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["private-eu-central-1b"]
    }
    "private-eu-central-1c" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["private-eu-central-1c"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["private-eu-central-1c"]
    }
    "lb-eu-central-1a" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["lb-eu-central-1a"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["lb-eu-central-1a"]
    }
    "lb-eu-central-1b" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["lb-eu-central-1b"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["lb-eu-central-1b"]
    }
    "lb-eu-central-1c" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["lb-eu-central-1c"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["lb-eu-central-1c"]
    }
    mgmt = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["mgmt"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["mgmt"]
    }
  }
}
