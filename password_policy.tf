resource "aws_iam_account_password_policy" "dq_password_policy" {
  provider                     = aws.ENV_ACCT
  minimum_password_length      = 14
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_numbers              = true
  require_symbols              = true
  max_password_age             = 90
  password_reuse_prevention    = 5
}
