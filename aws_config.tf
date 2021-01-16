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

resource "aws_iam_role_policy" "dq_aws_config_policy" {
  provider = aws.ENV_ACCT
  name     = "${var.config_name}-${var.namespace}-policy"
  role     = aws_iam_role.dq_aws_config_role.id

  policy = <<EOF
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
      "Resource": "${var.kms_key_s3[var.namespace]}"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "dq_aws_config_policy_attachement" {
  role       = "${aws_iam_role.dq_aws_config_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_config_configuration_recorder" "dq_aws_config_recorder" {
  name     = "${var.config_name}-${var.namespace}-configuration-recorder"
  role_arn = "${aws_iam_role.dq_aws_config_role.arn}"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "dq_aws_config_delivery_channel" {
  name           = "${var.config_name}-${var.namespace}-delivery-channel"
  s3_bucket_name = "${var.config_bucket}-${var.namespace}"

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_configuration_recorder_status" "dq_aws_config_config_status" {
  name       = aws_config_configuration_recorder.dq_aws_config_recorder.name
  is_enabled = true

  depends_on = ["aws_config_delivery_channel.dq_aws_config_delivery_channel"]
}

#S3 Configuration Rules--------------------------------------------------------

resource "aws_config_config_rule" "s3_bucket_versioning_enabled" {
  name = var.config_rule["s3_bucket_versioning_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_versioning_enabled_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "s3_bucket_level_public_access_prohibited" {
  name = var.config_rule["s3_bucket_level_public_access_prohibited"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_level_public_access_prohibited_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "s3_account_level_public_access_blocks" {
  name = var.config_rule["s3_account_level_public_access_blocks"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_account_level_public_access_blocks_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "s3_bucket_logging_enabled" {
  name = var.config_rule["s3_bucket_logging_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_logging_enabled_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  name = var.config_rule["s3_bucket_public_read_prohibited"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_public_read_prohibited_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "s3_bucket_public_write_prohibited" {
  name = var.config_rule["s3_bucket_public_write_prohibited"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_public_write_prohibited_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "s3_bucket_server_side_encryption_enabled" {
  name = var.config_rule["s3_bucket_server_side_encryption_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_server_side_encryption_enabled_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "s3_bucket_ssl_requests_only" {
  name = var.config_rule["s3_bucket_ssl_requests_only"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["s3_bucket_ssl_requests_only_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

#RDS Configuration Rules--------------------------------------------------------

resource "aws_config_config_rule" "rds_cluster_deletion_protection_enabled" {
  name = var.config_rule["rds_cluster_deletion_protection_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_cluster_deletion_protection_enabled_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_cluster_iam_authentication_enabled" {
  name = var.config_rule["rds_cluster_iam_authentication_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_cluster_iam_authentication_enabled_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_instance_deletion_protection_enabled" {
  name = var.config_rule["rds_instance_deletion_protection_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_instance_deletion_protection_enabled_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_instance_iam_authentication_enabled" {
  name = var.config_rule["rds_instance_iam_authentication_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_instance_iam_authentication_enabled_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_logging_enabled" {
  name = var.config_rule["rds_logging_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_logging_enabled_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_in_backup_plan" {
  name = var.config_rule["rds_in_backup_plan"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_in_backup_plan_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_snapshot_encrypted" {
  name = var.config_rule["rds_snapshot_encrypted"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_snapshot_encrypted_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_instance_public_access_check" {
  name = var.config_rule["rds_instance_public_access_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_instance_public_access_check_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_multi_az_support" {
  name = var.config_rule["rds_multi_az_support"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_multi_az_support_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_snapshots_public_prohibited" {
  name = var.config_rule["rds_snapshots_public_prohibited"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_snapshots_public_prohibited_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "rds_storage_encrypted" {
  name = var.config_rule["rds_storage_encrypted"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["rds_storage_encrypted_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

#IAM Configuration Rules--------------------------------------------------------

resource "aws_config_config_rule" "iam_no_inline_policy_check" {
  name = var.config_rule["iam_no_inline_policy_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_no_inline_policy_check_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "iam_group_has_users_check" {
  name = var.config_rule["iam_group_has_users_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_group_has_users_check_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "iam_policy_no_statements_with_admin_access" {
  name = var.config_rule["iam_policy_no_statements_with_admin_access"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_policy_no_statements_with_admin_access_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "iiam_user_mfa_enabled" {
  name = var.config_rule["iam_user_mfa_enabled"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_user_mfa_enabled_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "iam_user_no_policies_check" {
  name = var.config_rule["iam_user_no_policies_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_user_no_policies_check_id"]
  }

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

resource "aws_config_config_rule" "iam_user_unused_credentials_check" {
  name = var.config_rule["iam_user_unused_credentials_check"]

  source {
    owner             = "AWS"
    source_identifier = var.source_identifier["iam_user_unused_credentials_check_id"]
  }

  input_parameters = <<EOF
{
  "maxCredentialUsageAge" : "90"
}
EOF

  depends_on = aws_config_configuration_recorder.dq_aws_config_recorder
}

#
# resource "aws_config_config_rule" "instances_in_vpc" {
#   name = "instances_in_vpc"
#
#   source {
#     owner             = "AWS"
#     source_identifier = "INSTANCES_IN_VPC"
#   }
#
#   depends_on = ["aws_config_configuration_recorder.my-config"]
# }
#
# resource "aws_config_config_rule" "cloud_trail_enabled" {
#   name = "cloud_trail_enabled"
#
#   source {
#     owner             = "AWS"
#     source_identifier = "CLOUD_TRAIL_ENABLED"
#   }
#
#   input_parameters = <<EOF
# {
#   "s3BucketName": "cloudwatch-to-s3-logs"
# }
# EOF
#
#   depends_on = ["aws_config_configuration_recorder.my-config"]
# }
#
# resource "aws_config_config_rule" "s3_bucket_versioning_enabled" {
#   name = "s3_bucket_versioning_enabled"
#
#   source {
#     owner             = "AWS"
#     source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
#   }
#
#   depends_on = ["aws_config_configuration_recorder.my-config"]
# }
#
# resource "aws_config_config_rule" "desired_instance_type" {
#   name = "desired_instance_type"
#
#   "source" {
#     owner             = "AWS"
#     source_identifier = "DESIRED_INSTANCE_TYPE"
#   }
#
#   input_parameters = <<EOF
# {
#   "alarmActionRequired" : "t2.micro"
# }
# EOF
#
#   depends_on = ["aws_config_configuration_recorder.my-config"]
# }
