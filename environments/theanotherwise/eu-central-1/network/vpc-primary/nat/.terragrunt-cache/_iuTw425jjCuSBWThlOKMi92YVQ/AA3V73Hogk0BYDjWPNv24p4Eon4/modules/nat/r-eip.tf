resource "aws_eip" "r-this" {
  for_each = var.v-nats

  domain = "vpc"

  tags = merge(var.v-tags, each.value.tags, {
    Name = "${each.key}-eip"
  })

  lifecycle {
    create_before_destroy = false
  }
}
