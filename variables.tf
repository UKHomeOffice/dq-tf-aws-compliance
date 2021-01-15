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

variable "kms_key_s3" {
  type        = map(string)
  description = "The ARN of the KMS key that is used to encrypt S3 buckets"
  default = {
    test    = "arn:aws:kms:eu-west-2:797728447925:key/ad7169c4-6d6a-4d21-84ee-a3b54f4bef87"
    notprod = "arn:aws:kms:eu-west-2:483846886818:key/24b0cd4f-3117-4e9b-ada8-fa46e7fd6d70"
    prod    = "arn:aws:kms:eu-west-2:337779336338:key/ae75113d-f4f6-49c6-a15e-e8493fda0453"
  }
}

variable "config_bucket" {
  default = "s3-dq-aws-config"
}
