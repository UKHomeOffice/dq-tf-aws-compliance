resource "aws_s3_bucket" "dq_aws_config" {
  bucket = var.s3_bucket_name["dq-aws-config"]
  acl    = var.s3_bucket_acl["dq-aws-config"]

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "dq-aws-config/"
  }

  tags = {
    Name = "s3-dq-aws-config-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "dq-aws-config_bucket_policy" {
  bucket = var.s3_bucket_name["dq-aws-config"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["dq-aws-config"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY

}

resource "aws_s3_bucket_metric" "dq-aws-config_bucket_logging" {
  bucket = var.s3_bucket_name["dq-aws-config"]
  name   = "dq-aws-config_metric"
}
