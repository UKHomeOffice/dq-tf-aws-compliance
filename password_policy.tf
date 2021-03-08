resource "aws_iam_account_password_policy" "dq_password_policy" {
  provider                = aws.ENV_ACCT
  minimum_password_length = 14
}
