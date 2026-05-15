variable "iam_role_policy_attachments" {
  type = map(object({
    role       = string
    policy_arn = string
  }))
}
