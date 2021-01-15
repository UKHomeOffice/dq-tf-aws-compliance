resource "aws_s3_bucket" "dq_aws_config" {
  bucket = "s3-${var.config_name}-${var.namespace}"
  acl    = "private"

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
    Name = "s3-${var.config_name}-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "dq-aws-config_bucket_policy" {
  bucket = aws_s3_bucket.dq_aws_config.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::s3-${var.config_name}-${var.namespace}/*",
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
  bucket = aws_s3_bucket.dq_aws_config.name
  name   = "dq-aws-config_metric"
}
