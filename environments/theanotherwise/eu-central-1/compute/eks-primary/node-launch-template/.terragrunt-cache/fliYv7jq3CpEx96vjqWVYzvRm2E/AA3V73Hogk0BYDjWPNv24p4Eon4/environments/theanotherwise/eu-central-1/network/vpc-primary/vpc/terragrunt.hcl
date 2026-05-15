include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/vpc"
}

inputs = {
  vpc = {
    name       = "primary"
    cidr_block = "10.0.0.0/16"
  }

  internet_gateway_enabled = true
}
