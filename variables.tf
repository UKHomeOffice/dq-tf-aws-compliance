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

variable "config_rule" {
  type = map(string)
  default = {
    s3_bucket_versioning_enabled             = "DQ_s3_bucket_versioning_enabled"
    s3_bucket_level_public_access_prohibited = "DQ_s3_bucket_level_public_access_prohibited"
    s3_account_level_public_access_blocks    = "DQ_s3_account_level_public_access_blocks"
    s3_bucket_logging_enabled                = "DQ_s3_bucket_logging_enabled"
    s3_bucket_public_read_prohibited         = "DQ_s3_bucket_public_read_prohibited"
    s3_bucket_public_write_prohibited        = "DQ_s3_bucket_public_write_prohibited"
    s3_bucket_server_side_encryption_enabled = "DQ_s3_bucket_server_side_encryption_enabled"
    s3_bucket_ssl_requests_only              = "DQ_s3_bucket_ssl_requests_only"
  }
}

variable "source_identifier" {
  type = map(string)
  default = {
    bucket_versioning_enabled_id                = "S3_BUCKET_VERSIONING_ENABLED"
    s3_bucket_level_public_access_prohibited_id = "S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED"
    s3_account_level_public_access_blocks_id    = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
    s3_bucket_logging_enabled_id                = "S3_BUCKET_LOGGING_ENABLED"
    s3_bucket_public_read_prohibited_id         = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
    s3_bucket_public_write_prohibited_id        = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
    s3_bucket_server_side_encryption_enabled_id = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
    s3_bucket_ssl_requests_only_id              = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }
}
