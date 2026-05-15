moved {
  from = aws_iam_role_policy_attachment.r-this
  to   = aws_iam_role_policy_attachment.this
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.iam_role_policy_attachments

  role       = each.value.role
  policy_arn = each.value.policy_arn
}
