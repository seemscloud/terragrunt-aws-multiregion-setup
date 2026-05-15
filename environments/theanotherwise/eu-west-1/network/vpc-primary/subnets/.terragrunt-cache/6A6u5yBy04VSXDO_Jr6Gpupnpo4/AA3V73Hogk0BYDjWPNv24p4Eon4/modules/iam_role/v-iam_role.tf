variable "iam_role" {
  type = object({
    name               = string
    assume_role_policy = string
    tags               = optional(map(string), {})
  })

  validation {
    condition     = length(var.iam_role.name) > 0
    error_message = "IAM role name is required."
  }

  validation {
    condition     = length(var.iam_role.assume_role_policy) > 0
    error_message = "IAM role assume role policy is required."
  }
}
