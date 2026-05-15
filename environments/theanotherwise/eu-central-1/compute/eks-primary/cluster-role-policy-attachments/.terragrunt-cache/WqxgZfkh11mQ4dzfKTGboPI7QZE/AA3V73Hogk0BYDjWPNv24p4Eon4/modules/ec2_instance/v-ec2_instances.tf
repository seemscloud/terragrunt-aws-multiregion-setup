variable "ec2_instances" {
  type = map(object({
    name                        = optional(string)
    ami_ssm_parameter_name      = string
    instance_type               = string
    subnet_id                   = string
    associate_public_ip_address = optional(bool, false)
    vpc_security_group_ids      = optional(list(string), [])
    user_data                   = optional(string)
    root_block_device = object({
      volume_size = number
      volume_type = string
    })
    tags = optional(map(string), {})
  }))
}
