variable "launch_templates" {
  type = map(object({
    name = optional(string)
    block_device_mappings = list(object({
      device_name = string
      ebs = object({
        volume_size = number
        volume_type = string
      })
    }))
    tags = optional(map(string), {})
  }))

  validation {
    condition     = alltrue([for launch_template in var.launch_templates : length(launch_template.block_device_mappings) > 0])
    error_message = "Each launch template requires at least one block device mapping."
  }
}
