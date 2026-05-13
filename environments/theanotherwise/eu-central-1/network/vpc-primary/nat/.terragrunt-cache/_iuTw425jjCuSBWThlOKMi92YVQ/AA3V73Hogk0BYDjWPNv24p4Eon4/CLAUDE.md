# Project rules for Claude

## Scope discipline — only build what the user asked for

When the user asks for module `X`, build **only** `X`. Do not bundle in adjacent resources, supporting infrastructure, "best-practice" extras, or anything else that was not explicitly requested.

Concrete examples:

- "Create a VPC module" → module contains the VPC resource only. **No** subnets, **no** internet gateway, **no** NAT gateway, **no** EIPs, **no** route tables, **no** route table associations, **no** VPC endpoints, **no** flow logs, **no** DHCP options. Even though these are commonly grouped with a VPC, they each belong in their own dedicated module that the user will ask for separately.
- "Create a subnet module" → only `aws_subnet`. Routing, NAT, and IGW go in their own modules.
- "Create an EKS module" → only the EKS cluster resource. Node groups, IAM roles, addons, OIDC provider — separate modules.

Rationale: the user wants fine-grained, composable modules with a single responsibility. Bundling extras forces a redesign every time we want to use the supposedly-monolithic module in a context that doesn't need all of its parts. One resource type per module unless the user explicitly says otherwise.

## Do not add anything the user did not request

This applies beyond modules:

- Do not add example files, README files, `.gitignore`, CI configs, pre-commit hooks, makefiles, or helper scripts unless asked.
- Do not add optional variables "just in case" (TLS settings, monitoring toggles, logging hooks, extra tags, lifecycle blocks). If the user did not name it, do not add it.
- Do not add outputs that the current consumers do not need.
- Do not add provider features (default tags, retries, custom endpoints) unless requested.

When in doubt: produce the minimum that satisfies the request and stop. Ask if more is needed — do not assume.

## Flag follow-up requirements clearly — do not silently leave the user stuck

Scope discipline does **not** mean staying quiet when the thing being built is non-functional in isolation. After delivering what the user asked for, explicitly state — at the top of the reply, not buried in a footnote — what additional modules or components are required for the delivered piece to actually do its job.

Examples:

- Built a NAT module without routing → say loudly: "NAT gateways will sit idle and cost money until a routing module is added with private route tables and `0.0.0.0/0 → NAT` routes. Do you want me to build that next?"
- Built a subnet module without route table associations → say: "These subnets have no routing yet. They will exist in the VPC but cannot reach anything outside their CIDR until route tables and associations are configured."
- Built an EKS cluster without IAM roles, node groups, or addons → say: "This cluster won't schedule pods until node groups + IAM roles + the core addons (VPC CNI, CoreDNS, kube-proxy) are added. Want me to lay those out as separate modules?"

The rule: respect single-responsibility module scope, **but never let scope discipline be an excuse for delivering a half-working setup without warning**. Always surface the next-step dependencies as a clear, separate item at the top of the response — not a soft footnote — and offer to build them next.

## No comments in code

No comments anywhere in `.tf`, `.hcl`, or any other code file. No banners, no section dividers, no inline `#`/`//` notes. Explanations belong in chat, not in files.

## Terraform / Terragrunt file and naming conventions

Split each module into many small files, one element per file:

- `r-<resource_type>.tf` — one file per resource type, with the `aws_` provider prefix stripped. Examples: `r-vpc.tf`, `r-subnet.tf`, `r-route.tf`, `r-route_table.tf`, `r-internet_gateway.tf`, `r-nat_gateway.tf`, `r-eip.tf`. Multiple `resource` blocks of the same type live in the same file.
- `v-<variable_name>.tf` — one file per `variable` block. The variable itself is also prefixed with `v-` (e.g. `variable "v-vpc"`, `variable "v-subnets"`).
- Resource labels (the second positional argument to `resource`) are prefixed with `r-`: `resource "aws_vpc" "r-this"`, `resource "aws_subnet" "r-public"`. Dashes in HCL identifiers are valid.
- Variables of grouped configuration use `type = object({ ... })` to keep related fields together.
- `outputs.tf` and `versions.tf` stay flat (no prefix).
- Locals live in the `r-*.tf` file of the resource that needs them, not in a separate `locals.tf`.

## State layout

State is stored remotely and the path inside the bucket mirrors the directory layout under `environments/`, one state file per leaf `terragrunt.hcl`. This is configured in `root.hcl` via `path_relative_to_include()`. Do not collapse multiple environments or components into a shared state file.
