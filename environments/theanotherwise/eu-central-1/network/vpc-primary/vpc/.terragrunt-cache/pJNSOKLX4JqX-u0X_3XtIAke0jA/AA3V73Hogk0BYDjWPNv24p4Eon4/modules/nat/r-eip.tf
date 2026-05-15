resource "aws_eip" "this" {
  for_each = var.nats

  domain = "vpc"

  tags = merge(var.tags, each.value.tags, {
    Name = "${coalesce(each.value.name, each.key)}-eip"
  })

  lifecycle {
    create_before_destroy = false
  }
}
