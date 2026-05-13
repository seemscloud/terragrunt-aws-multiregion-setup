include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/vpc"
}

inputs = {
  v-vpc = {
    name       = "primary"
    cidr_block = "10.1.0.0/16"
  }

  v-internet-gateway-enabled = true
}
