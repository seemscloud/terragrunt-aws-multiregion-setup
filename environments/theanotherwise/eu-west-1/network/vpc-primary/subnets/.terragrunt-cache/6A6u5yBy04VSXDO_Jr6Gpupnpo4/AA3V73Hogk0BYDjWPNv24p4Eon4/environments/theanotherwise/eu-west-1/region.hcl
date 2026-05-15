locals {
  aws_region = "eu-west-1"

  azs = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c",
  ]

  region_tags = {
    Region = "eu-west-1"
  }
}
