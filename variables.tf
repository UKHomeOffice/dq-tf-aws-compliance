variable "ENV_ACCT_ID" {
}

variable "ENV_ACCT_KEY" {
}

variable "namespace" {
  default = "test"
}

variable "config_name" {
  default = "dq-aws-config"
}

s3_bucket_name = {
  dq_aws_config = "s3-dq-log-archive-bucket-${var.NAMESPACE}"
}

s3_bucket_acl = {
  dq_aws_config = "private"
}
