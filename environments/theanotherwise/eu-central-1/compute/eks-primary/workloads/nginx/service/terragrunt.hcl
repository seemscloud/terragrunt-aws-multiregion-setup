include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/kubernetes_service"
}

dependency "cluster" {
  config_path = "../../../cluster"

  mock_outputs = {
    cluster_name                       = "primary-eu-central-1"
    cluster_endpoint                   = "https://mock.eks.local"
    cluster_certificate_authority_data = "dGVzdA=="
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "subnets" {
  config_path = "../../../../../network/vpc-primary/subnets"

  mock_outputs = {
    subnet_ids = {
      "lb-eu-central-1a" = "subnet-mock-lb-a"
      "lb-eu-central-1b" = "subnet-mock-lb-b"
      "lb-eu-central-1c" = "subnet-mock-lb-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependencies {
  paths = ["../deployment"]
}

generate "kubernetes_provider" {
  path      = "kubernetes-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "aws_eks_cluster_auth" "this" {
  name = "${dependency.cluster.outputs.cluster_name}"
}

provider "kubernetes" {
  host                   = "${dependency.cluster.outputs.cluster_endpoint}"
  cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_certificate_authority_data}")
  token                  = data.aws_eks_cluster_auth.this.token
}
EOF
}

inputs = {
  services = {
    nginx = {
      namespace = "default"
      type      = "LoadBalancer"
      selector = {
        app = "nginx"
      }
      annotations = {
        "service.beta.kubernetes.io/aws-load-balancer-internal" = "true"
        "service.beta.kubernetes.io/aws-load-balancer-scheme"   = "internal"
        "service.beta.kubernetes.io/aws-load-balancer-subnets" = join(",", [
          dependency.subnets.outputs.subnet_ids["lb-eu-central-1a"],
          dependency.subnets.outputs.subnet_ids["lb-eu-central-1b"],
          dependency.subnets.outputs.subnet_ids["lb-eu-central-1c"],
        ])
        "service.beta.kubernetes.io/aws-load-balancer-target-group-attributes" = "preserve_client_ip.enabled=false"
        "service.beta.kubernetes.io/aws-load-balancer-type"                    = "nlb"
      }
      load_balancer_source_ranges = [
        "10.0.20.0/24",
        "10.0.21.0/24",
        "10.0.22.0/24",
        "10.0.255.240/28",
      ]
      wait_for_load_balancer = true
      port = {
        name        = "http"
        port        = 80
        target_port = 80
      }
    }
  }
}
