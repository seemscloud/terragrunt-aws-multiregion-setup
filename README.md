# terraform-aws-demo

Terragrunt/OpenTofu project for a multi-region AWS dev environment. The deployable stack lives under `environments/theanotherwise`; reusable single-purpose Terraform modules live under `modules`.

## Architecture

The environment is built as three workload regions connected through a Transit Gateway hub in `eu-central-1`. Each workload region has one `primary` VPC, one `primary` EKS cluster, one `mgmt` instance, regional private DNS, and dedicated subnets for public, private/EKS, internal load balancers, and Transit Gateway attachments.

```mermaid
flowchart LR
    Internet["Internet"]

    subgraph Hub["eu-central-1 - Transit Gateway hub"]
        HubTGW["hub TGW"]
        HubRoutes["hub TGW routes<br/>10.1.10/24-10.1.22/24<br/>10.2.10/24-10.2.22/24<br/>10.3.10/24-10.3.22/24"]
        HubTGW --- HubRoutes
    end

    subgraph West1["eu-west-1 - primary workload VPC 10.1.0.0/16"]
        W1Public["public subnets<br/>10.1.0.0/24<br/>10.1.1.0/24<br/>10.1.2.0/24"]
        W1Private["EKS private subnets<br/>10.1.10.0/24<br/>10.1.11.0/24<br/>10.1.12.0/24"]
        W1LB["internal LB subnets<br/>10.1.20.0/24<br/>10.1.21.0/24<br/>10.1.22.0/24"]
        W1TGWSubnets["TGW subnets<br/>10.1.30.0/28<br/>10.1.30.16/28<br/>10.1.30.32/28"]
        W1Mgmt["mgmt instance<br/>10.1.255.240/28"]
        W1EKS["EKS primary"]
        W1Nginx["nginx service<br/>nginx.default.primary.eks.eu-west-1.aws.seems.cloud"]
        W1Zone["private hosted zone<br/>primary.eks.eu-west-1.aws.seems.cloud"]
        W1TGW["regional TGW"]

        W1Public --> W1NAT["NAT gateways"]
        W1Private --> W1EKS
        W1EKS --> W1Nginx
        W1Nginx --> W1LB
        W1TGWSubnets --> W1TGW
        W1Zone -.-> W1Nginx
    end

    subgraph West2["eu-west-2 - primary workload VPC 10.2.0.0/16"]
        W2Public["public subnets<br/>10.2.0.0/24<br/>10.2.1.0/24<br/>10.2.2.0/24"]
        W2Private["EKS private subnets<br/>10.2.10.0/24<br/>10.2.11.0/24<br/>10.2.12.0/24"]
        W2LB["internal LB subnets<br/>10.2.20.0/24<br/>10.2.21.0/24<br/>10.2.22.0/24"]
        W2TGWSubnets["TGW subnets<br/>10.2.30.0/28<br/>10.2.30.16/28<br/>10.2.30.32/28"]
        W2Mgmt["mgmt instance<br/>10.2.255.240/28"]
        W2EKS["EKS primary"]
        W2Nginx["nginx service<br/>nginx.default.primary.eks.eu-west-2.aws.seems.cloud"]
        W2Zone["private hosted zone<br/>primary.eks.eu-west-2.aws.seems.cloud"]
        W2TGW["regional TGW"]

        W2Public --> W2NAT["NAT gateways"]
        W2Private --> W2EKS
        W2EKS --> W2Nginx
        W2Nginx --> W2LB
        W2TGWSubnets --> W2TGW
        W2Zone -.-> W2Nginx
    end

    subgraph West3["eu-west-3 - primary workload VPC 10.3.0.0/16"]
        W3Public["public subnets<br/>10.3.0.0/24<br/>10.3.1.0/24<br/>10.3.2.0/24"]
        W3Private["EKS private subnets<br/>10.3.10.0/24<br/>10.3.11.0/24<br/>10.3.12.0/24"]
        W3LB["internal LB subnets<br/>10.3.20.0/24<br/>10.3.21.0/24<br/>10.3.22.0/24"]
        W3TGWSubnets["TGW subnets<br/>10.3.30.0/28<br/>10.3.30.16/28<br/>10.3.30.32/28"]
        W3Mgmt["mgmt instance<br/>10.3.255.240/28"]
        W3EKS["EKS primary"]
        W3Nginx["nginx service<br/>nginx.default.primary.eks.eu-west-3.aws.seems.cloud"]
        W3Zone["private hosted zone<br/>primary.eks.eu-west-3.aws.seems.cloud"]
        W3TGW["regional TGW"]

        W3Public --> W3NAT["NAT gateways"]
        W3Private --> W3EKS
        W3EKS --> W3Nginx
        W3Nginx --> W3LB
        W3TGWSubnets --> W3TGW
        W3Zone -.-> W3Nginx
    end

    Internet -->|SSH to mgmt| W1Mgmt
    Internet -->|SSH to mgmt| W2Mgmt
    Internet -->|SSH to mgmt| W3Mgmt
    Internet -->|EKS API 443| W1EKS
    Internet -->|EKS API 443| W2EKS
    Internet -->|EKS API 443| W3EKS

    W1TGW <-->|TGW peering| HubTGW
    W2TGW <-->|TGW peering| HubTGW
    W3TGW <-->|TGW peering| HubTGW

    W1EKS -->|remote service traffic via DNS and TGW hub| W2LB
    W1EKS -->|remote service traffic via DNS and TGW hub| W3LB
    W2EKS -->|remote service traffic via DNS and TGW hub| W1LB
    W2EKS -->|remote service traffic via DNS and TGW hub| W3LB
    W3EKS -->|remote service traffic via DNS and TGW hub| W1LB
    W3EKS -->|remote service traffic via DNS and TGW hub| W2LB
```

## Regional layout

| Region | VPC CIDR | Public subnets | EKS private subnets | Internal LB subnets | TGW subnets | Mgmt subnet |
| --- | --- | --- | --- | --- | --- | --- |
| `eu-west-1` | `10.1.0.0/16` | `10.1.0.0/24`, `10.1.1.0/24`, `10.1.2.0/24` | `10.1.10.0/24`, `10.1.11.0/24`, `10.1.12.0/24` | `10.1.20.0/24`, `10.1.21.0/24`, `10.1.22.0/24` | `10.1.30.0/28`, `10.1.30.16/28`, `10.1.30.32/28` | `10.1.255.240/28` |
| `eu-west-2` | `10.2.0.0/16` | `10.2.0.0/24`, `10.2.1.0/24`, `10.2.2.0/24` | `10.2.10.0/24`, `10.2.11.0/24`, `10.2.12.0/24` | `10.2.20.0/24`, `10.2.21.0/24`, `10.2.22.0/24` | `10.2.30.0/28`, `10.2.30.16/28`, `10.2.30.32/28` | `10.2.255.240/28` |
| `eu-west-3` | `10.3.0.0/16` | `10.3.0.0/24`, `10.3.1.0/24`, `10.3.2.0/24` | `10.3.10.0/24`, `10.3.11.0/24`, `10.3.12.0/24` | `10.3.20.0/24`, `10.3.21.0/24`, `10.3.22.0/24` | `10.3.30.0/28`, `10.3.30.16/28`, `10.3.30.32/28` | `10.3.255.240/28` |

## Traffic model

- Internet can reach the public EKS API endpoint in each workload region.
- Internet can reach each regional `mgmt` instance over SSH.
- Each regional `mgmt` instance can reach local EKS nodes in the same region.
- EKS workloads reach services in other regions through private DNS, internal NLB addresses, regional TGWs, and the `eu-central-1` TGW hub.
- Private hosted zones are regional by name, but each zone is associated with all workload VPCs, so every cluster can resolve every regional service name.
- The VPC CNI add-on excludes remote load balancer CIDRs from SNAT, and the test NLB service preserves client IPs so remote services can see pod source IPs.

## Main service names

| Region | Service DNS name |
| --- | --- |
| `eu-west-1` | `nginx.default.primary.eks.eu-west-1.aws.seems.cloud` |
| `eu-west-2` | `nginx.default.primary.eks.eu-west-2.aws.seems.cloud` |
| `eu-west-3` | `nginx.default.primary.eks.eu-west-3.aws.seems.cloud` |
