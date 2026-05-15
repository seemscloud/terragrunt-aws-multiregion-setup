data "aws_ssm_parameter" "ami" {
  for_each = var.ec2_instances

  name = each.value.ami_ssm_parameter_name
}

resource "aws_instance" "this" {
  for_each = var.ec2_instances

  ami                         = data.aws_ssm_parameter.ami[each.key].value
  instance_type               = each.value.instance_type
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = each.value.associate_public_ip_address
  vpc_security_group_ids      = each.value.vpc_security_group_ids
  user_data                   = each.value.user_data

  root_block_device {
    volume_size = each.value.root_block_device.volume_size
    volume_type = each.value.root_block_device.volume_type
  }

  tags = merge(var.tags, each.value.tags, {
    Name = coalesce(each.value.name, each.key)
  })
}
