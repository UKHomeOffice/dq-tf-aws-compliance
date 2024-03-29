data "aws_caller_identity" "current" {
}

resource "aws_kms_key" "comp_bucket_key" {
  description             = "This key is used to encrypt daily tasks buckets"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "aws-compliance-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions for aws compliance",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "${data.aws_caller_identity.current.arn}",
                  "${data.aws_caller_identity.current.account_id}"
                ]
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF

}
