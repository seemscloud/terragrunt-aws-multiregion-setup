moved {
  from = aws_iam_role.r-this
  to   = aws_iam_role.this
}

resource "aws_iam_role" "this" {
  name               = var.iam_role.name
  assume_role_policy = var.iam_role.assume_role_policy

  tags = merge(var.tags, var.iam_role.tags)
}
