resource "aws_iam_role" "config_recorder" {
  provider = aws.ENV_ACCT
  name     = "config_recorder"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF


  tags = {
    Name = "${var.config_recorder_name}-${var.namespace}-Role"
  }

  count = var.pipeline_count
}
