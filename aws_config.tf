provider "aws" {
  alias      = "ENV_ACCT"
  region     = "eu-west-2"
  access_key = var.ENV_ACCT_ID
  secret_key = var.ENV_ACCT_KEY
}

resource "aws_iam_role" "dq_aws_config_role" {
  provider = aws.ENV_ACCT
  name     = "${var.config_name}-${var.namespace}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "dq_aws_config_policy" {
  provider = aws.ENV_ACCT
  name     = "${var.config_name}-${var.namespace}-policy"

  policy     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.config_bucket}-${var.namespace}",
        "arn:aws:s3:::${var.config_bucket}-${var.namespace}/*"]
    },
    {
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Effect": "Allow",
      "Resource": ["${aws_kms_key.comp_bucket_key.arn}"]
    }
  ]
}
EOF
  depends_on = [aws_kms_key.comp_bucket_key]
}

resource "aws_iam_role_policy_attachment" "dq_aws_config_policy" {
  role       = aws_iam_role.dq_aws_config_role.id
  policy_arn = aws_iam_policy.dq_aws_config_policy.arn
}

resource "aws_iam_role_policy_attachment" "dq_aws_config_policy_attachement" {
  provider   = aws.ENV_ACCT
  role       = aws_iam_role.dq_aws_config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_config_configuration_recorder" "dq_aws_config_recorder" {
  provider = aws.ENV_ACCT
  name     = "${var.config_name}-${var.namespace}-configuration-recorder"
  role_arn = aws_iam_role.dq_aws_config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "dq_aws_config_delivery_channel" {
  provider       = aws.ENV_ACCT
  name           = "${var.config_name}-${var.namespace}-delivery-channel"
  s3_bucket_name = "${var.config_bucket}-${var.namespace}"

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_configuration_recorder_status" "dq_aws_config_config_status" {
  provider   = aws.ENV_ACCT
  name       = aws_config_configuration_recorder.dq_aws_config_recorder.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.dq_aws_config_delivery_channel]
}

#S3 Configuration Rules--------------------------------------------------------

resource "aws_config_config_rule" "s3_bucket_versioning_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["s3_bucket_versioning_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_versioning_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "s3_bucket_level_public_access_prohibited" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["s3_bucket_level_public_access_prohibited"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_level_public_access_prohibited_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "s3_account_level_public_access_blocks" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["s3_account_level_public_access_blocks"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_account_level_public_access_blocks_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "s3_bucket_logging_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["s3_bucket_logging_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_logging_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["s3_bucket_public_read_prohibited"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_public_read_prohibited_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "s3_bucket_public_write_prohibited" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["s3_bucket_public_write_prohibited"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_public_write_prohibited_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "s3_bucket_server_side_encryption_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["s3_bucket_server_side_encryption_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_server_side_encryption_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "s3_bucket_ssl_requests_only" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["s3_bucket_ssl_requests_only"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_ssl_requests_only_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

#RDS Configuration Rules--------------------------------------------------------

resource "aws_config_config_rule" "rds_cluster_deletion_protection_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_cluster_deletion_protection_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_cluster_deletion_protection_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_cluster_iam_authentication_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_cluster_iam_authentication_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_cluster_iam_authentication_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_instance_deletion_protection_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_instance_deletion_protection_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_instance_deletion_protection_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_instance_iam_authentication_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_instance_iam_authentication_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_instance_iam_authentication_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_logging_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_logging_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_logging_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_in_backup_plan" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_in_backup_plan"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_in_backup_plan_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_snapshot_encrypted" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_snapshot_encrypted"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_snapshot_encrypted_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_instance_public_access_check" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_instance_public_access_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_instance_public_access_check_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_multi_az_support" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_multi_az_support"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_multi_az_support_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_snapshots_public_prohibited" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_snapshots_public_prohibited"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_snapshots_public_prohibited_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "rds_storage_encrypted" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["rds_storage_encrypted"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_storage_encrypted_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

#IAM Configuration Rules--------------------------------------------------------

resource "aws_config_config_rule" "iam_no_inline_policy_check" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["iam_no_inline_policy_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_no_inline_policy_check_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "iam_group_has_users_check" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["iam_group_has_users_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_group_has_users_check_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "iam_policy_no_statements_with_admin_access" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["iam_policy_no_statements_with_admin_access"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_policy_no_statements_with_admin_access_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "iiam_user_mfa_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["iam_user_mfa_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_user_mfa_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "iam_user_no_policies_check" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["iam_user_no_policies_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_user_no_policies_check_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "iam_user_unused_credentials_check" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["iam_user_unused_credentials_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_user_unused_credentials_check_id"]
  }

  input_parameters = <<EOF
{
  "maxCredentialUsageAge" : "90"
}
EOF

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

#Other Configuration Rules--------------------------------------------------------

resource "aws_config_config_rule" "access_keys_rotated" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["access_keys_rotated"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["access_keys_rotated_id"]
  }

  input_parameters = <<EOF
{
  "maxAccessKeyAge" : "90"
}
EOF

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "cloudtrail_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["cloudtrail_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["cloudtrail_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "cloud_trail_encryption_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["cloud_trail_encryption_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["cloud_trail_encryption_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "cmk_backing_key_rotation_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["cmk_backing_key_rotation_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["cmk_backing_key_rotation_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "dynamodb_table_encrypted_kms" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["dynamodb_table_encrypted_kms"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["dynamodb_table_encrypted_kms_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "dynamodb_table_encryption_enabled" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["dynamodb_table_encryption_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["dynamodb_table_encryption_enabled_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "ec2_ebs_encryption_by_default" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["ec2_ebs_encryption_by_default"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["ec2_ebs_encryption_by_default_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "ebs_snapshot_public_restorable_check" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["ebs_snapshot_public_restorable_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["ebs_snapshot_public_restorable_check_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "efs_encrypted_check" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["efs_encrypted_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["efs_encrypted_check_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "encrypted_volumes" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["encrypted_volumes"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["encrypted_volumes_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "guardduty_enabled_centralized" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["guardduty_enabled_centralized"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["guardduty_enabled_centralized_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "kms_cmk_not_scheduled_for_deletion" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["kms_cmk_not_scheduled_for_deletion"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["kms_cmk_not_scheduled_for_deletion_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "lambda_function_public_access_prohibited" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["lambda_function_public_access_prohibited"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["lambda_function_public_access_prohibited_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "mfa_enabled_for_iam_console_access" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["mfa_enabled_for_iam_console_access"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["mfa_enabled_for_iam_console_access_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "sns_encrypted_kms" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["sns_encrypted_kms"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["sns_encrypted_kms_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "vpc_network_acl_unused_check" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["vpc_network_acl_unused_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["vpc_network_acl_unused_check_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}

resource "aws_config_config_rule" "vpc_sg_open_only_to_authorized_ports" {
  provider = aws.ENV_ACCT
  name     = var.config_rule["vpc_sg_open_only_to_authorized_ports"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["vpc_sg_open_only_to_authorized_ports_id"]
  }

  depends_on = [aws_config_configuration_recorder.dq_aws_config_recorder]
}
