include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/network_acl"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id         = "vpc-mock-eu-central-1"
    vpc_cidr_block = "10.0.0.0/16"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "subnets" {
  config_path = "../subnets"

  mock_outputs = {
    subnet_ids = {
      mgmt                    = "subnet-mock-mgmt"
      "private-eu-central-1a" = "subnet-mock-private-a"
      "private-eu-central-1b" = "subnet-mock-private-b"
      "private-eu-central-1c" = "subnet-mock-private-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

locals {
  mgmt_cidr_blocks      = ["10.0.255.240/28"]
  node_cidr_blocks      = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  peer_lb_cidr_blocks   = ["10.1.20.0/24", "10.1.21.0/24", "10.1.22.0/24"]
  node_ssh_deny_ingress = [for index, cidr in local.node_cidr_blocks : { rule_no = 100 + index, action = "deny", protocol = "tcp", from_port = 22, to_port = 22, cidr_block = cidr }]
  node_ssh_deny_egress  = [for index, cidr in local.mgmt_cidr_blocks : { rule_no = 100 + index, action = "deny", protocol = "tcp", from_port = 22, to_port = 22, cidr_block = cidr }]
  peer_lb_egress        = [for index, cidr in local.peer_lb_cidr_blocks : { rule_no = 120 + index, action = "allow", protocol = "-1", from_port = 0, to_port = 0, cidr_block = cidr }]
  peer_lb_ingress       = [for index, cidr in local.peer_lb_cidr_blocks : { rule_no = 110 + index, action = "allow", protocol = "-1", from_port = 0, to_port = 0, cidr_block = cidr }]
}

inputs = {
  network_acls = {
    mgmt = {
      vpc_id     = dependency.vpc.outputs.vpc_id
      subnet_ids = [dependency.subnets.outputs.subnet_ids["mgmt"]]
      ingress = concat(
        local.node_ssh_deny_ingress,
        [
          {
            rule_no    = 110
            action     = "allow"
            protocol   = "tcp"
            from_port  = 22
            to_port    = 22
            cidr_block = "0.0.0.0/0"
          },
          {
            rule_no    = 120
            action     = "allow"
            protocol   = "-1"
            from_port  = 0
            to_port    = 0
            cidr_block = dependency.vpc.outputs.vpc_cidr_block
          },
          {
            rule_no    = 130
            action     = "allow"
            protocol   = "tcp"
            from_port  = 1024
            to_port    = 65535
            cidr_block = "0.0.0.0/0"
          },
          {
            rule_no    = 140
            action     = "allow"
            protocol   = "udp"
            from_port  = 1024
            to_port    = 65535
            cidr_block = "0.0.0.0/0"
          },
        ]
      )
      egress = [
        {
          rule_no    = 100
          action     = "allow"
          protocol   = "-1"
          from_port  = 0
          to_port    = 0
          cidr_block = "0.0.0.0/0"
        },
      ]
      tags = {
        Tier = "mgmt"
      }
    }
    eks_private = {
      vpc_id = dependency.vpc.outputs.vpc_id
      subnet_ids = [
        dependency.subnets.outputs.subnet_ids["private-eu-central-1a"],
        dependency.subnets.outputs.subnet_ids["private-eu-central-1b"],
        dependency.subnets.outputs.subnet_ids["private-eu-central-1c"],
      ]
      ingress = concat(
        [
          {
            rule_no    = 100
            action     = "allow"
            protocol   = "-1"
            from_port  = 0
            to_port    = 0
            cidr_block = dependency.vpc.outputs.vpc_cidr_block
          },
        ],
        local.peer_lb_ingress
      )
      egress = concat(
        local.node_ssh_deny_egress,
        [
          {
            rule_no    = 110
            action     = "allow"
            protocol   = "-1"
            from_port  = 0
            to_port    = 0
            cidr_block = dependency.vpc.outputs.vpc_cidr_block
          },
        ],
        local.peer_lb_egress
      )
      tags = {
        Tier = "eks-private"
      }
    }
  }
}
