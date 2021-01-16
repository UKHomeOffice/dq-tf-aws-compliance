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
    s3_bucket_versioning_enabled               = "DQ_s3_bucket_versioning_enabled"
    s3_bucket_level_public_access_prohibited   = "DQ_s3_bucket_level_public_access_prohibited"
    s3_account_level_public_access_blocks      = "DQ_s3_account_level_public_access_blocks"
    s3_bucket_logging_enabled                  = "DQ_s3_bucket_logging_enabled"
    s3_bucket_public_read_prohibited           = "DQ_s3_bucket_public_read_prohibited"
    s3_bucket_public_write_prohibited          = "DQ_s3_bucket_public_write_prohibited"
    s3_bucket_server_side_encryption_enabled   = "DQ_s3_bucket_server_side_encryption_enabled"
    s3_bucket_ssl_requests_only                = "DQ_s3_bucket_ssl_requests_only"
    rds_cluster_deletion_protection_enabled    = "DQ_rds_cluster_deletion_protection_enabled"
    rds_cluster_iam_authentication_enabled     = "DQ_rds_cluster_iam_authentication_enabled"
    rds_instance_deletion_protection_enabled   = "DQ_rds_instance_deletion_protection_enabled"
    rds_instance_iam_authentication_enabled    = "DQ_rds_instance_iam_authentication_enabled"
    rds_logging_enabled                        = "DQ_rds_logging_enabled"
    rds_in_backup_plan                         = "DQ_rds_in_backup_plan"
    rds_snapshot_encrypted                     = "DQ_rds_snapshot_encrypted"
    rds_instance_public_access_check           = "DQ_rds_instance_public_access_check"
    rds_multi_az_support                       = "DQ_rds_multi_az_support"
    rds_snapshots_public_prohibited            = "DQ_rds_snapshots_public_prohibited"
    rds_storage_encrypted                      = "DQ_rds_storage_encrypted"
    iam_no_inline_policy_check                 = "DQ_iam_no_inline_policy_check"
    iam_group_has_users_check                  = "DQ_iam_group_has_users_check"
    iam_policy_no_statements_with_admin_access = "DQ_iam_policy_no_statements_with_admin_access"
    iam_user_mfa_enabled                       = "DQ_iam_user_mfa_enabled"
    iam_user_no_policies_check                 = "DQ_iam_user_no_policies_check"
    iam_user_unused_credentials_check          = "DQ_iam_user_unused_credentials_check"
  }
}

variable "source_identifier" {
  type = map(string)
  default = {
    s3_bucket_versioning_enabled_id               = "S3_BUCKET_VERSIONING_ENABLED"
    s3_bucket_level_public_access_prohibited_id   = "S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED"
    s3_account_level_public_access_blocks_id      = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
    s3_bucket_logging_enabled_id                  = "S3_BUCKET_LOGGING_ENABLED"
    s3_bucket_public_read_prohibited_id           = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
    s3_bucket_public_write_prohibited_id          = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
    s3_bucket_server_side_encryption_enabled_id   = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
    s3_bucket_ssl_requests_only_id                = "S3_BUCKET_SSL_REQUESTS_ONLY"
    rds_cluster_deletion_protection_enabled_id    = "RDS_CLUSTER_DELETION_PROTECTION_ENABLED"
    rds_cluster_iam_authentication_enabled_id     = "RDS_CLUSTER_IAM_AUTHENTICATION_ENABLED"
    rds_instance_deletion_protection_enabled_id   = "RDS_INSTANCE_DELETION_PROTECTION_ENABLED"
    rds_instance_iam_authentication_enabled_id    = "RDS_INSTANCE_IAM_AUTHENTICATION_ENABLED"
    rds_logging_enabled_id                        = "RDS_LOGGING_ENABLED"
    rds_in_backup_plan_id                         = "RDS_IN_BACKUP_PLAN"
    rds_snapshot_encrypted_id                     = "RDS_SNAPSHOT_ENCRYPTED"
    rds_instance_public_access_check_id           = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
    rds_multi_az_support_id                       = "RDS_MULTI_AZ_SUPPORT"
    rds_snapshots_public_prohibited_id            = "RDS_SNAPSHOTS_PUBLIC_PROHIBITED"
    rds_storage_encrypted_id                      = "RDS_STORAGE_ENCRYPTED"
    iam_no_inline_policy_check_id                 = "IAM_NO_INLINE_POLICY_CHECK"
    iam_group_has_users_check_id                  = "IAM_GROUP_HAS_USERS_CHECK"
    iam_policy_no_statements_with_admin_access_id = "IAM_POLICY_NO_STATEMENTS_WITH_ADMIN_ACCESS"
    iam_user_mfa_enabled_id                       = "IAM_USER_MFA_ENABLED"
    iam_user_no_policies_check_id                 = "IAM_USER_NO_POLICIES_CHECK"
    iam_user_unused_credentials_check_id          = "IAM_USER_UNUSED_CREDENTIALS_CHECK"
  }
}
