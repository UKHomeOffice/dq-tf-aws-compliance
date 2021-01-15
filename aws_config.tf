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
      "Action": "s3:*"
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::"${var.config_bucket}-${var.namespace}"",
        "arn:aws:s3:::"${var.config_bucket}-${var.namespace}"/*"]
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
#
# resource "aws_s3_bucket" "my-config" {
#   bucket = "config-bucket-for-my-test-project"
#   acl    = "private"
#
#   versioning {
#     enabled = true
#   }
#
#   lifecycle {
#     prevent_destroy = true
#   }
# }

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

  depends_on = ["aws_config_configuration_recorder.dq_aws_config_recorder"]
}

# resource "aws_config_configuration_recorder_status" "config" {
#   name       = "${aws_config_configuration_recorder.my-config.name}"
#   is_enabled = true
#
#   depends_on = ["aws_config_delivery_channel.my-config"]
# }
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
