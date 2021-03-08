resource "aws_iam_account_password_policy" "dq_password_policy" {
  minimum_password_length = 14
}
