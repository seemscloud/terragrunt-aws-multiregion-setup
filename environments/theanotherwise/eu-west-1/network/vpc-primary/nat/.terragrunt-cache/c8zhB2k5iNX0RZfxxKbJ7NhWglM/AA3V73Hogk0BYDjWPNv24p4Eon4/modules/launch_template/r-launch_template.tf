resource "aws_launch_template" "this" {
  for_each = var.launch_templates

  name = coalesce(each.value.name, each.key)

  dynamic "block_device_mappings" {
    for_each = each.value.block_device_mappings

    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size = block_device_mappings.value.ebs.volume_size
        volume_type = block_device_mappings.value.ebs.volume_type
      }
    }
  }

  tags = merge(var.tags, each.value.tags)
}
