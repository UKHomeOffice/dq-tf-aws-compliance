resource "aws_iam_role" "config_recorder_monitor_role" {
  provider = aws.ENV_ACCT
  name     = "config_recorder_monitor_role"

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
    Name = "AWS-Config-${var.config_name}-${var.namespace}"
  }

  count = var.pipeline_count
}

# resource "aws_iam_role_policy" "config_recorder_monitor_role" {
#   provider = aws.ENV_ACCT
#   name     = "config_recorder_monitor_role"
#   role     = aws_iam_role.config_recorder_monitor_role[0].id
#
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:GetObject",
#                 "s3:GetObjectVersion",
#                 "lambda:InvokeFunction",
#                 "s3:ListBucket"
#             ],
#             "Resource": [
#                 "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.config_name}-${var.namespace}-lambda",
#                 "arn:aws:s3:::${var.config_bucket}-${var.namespace}",
#                 "arn:aws:s3:::${var.config_bucket}-${var.namespace}/*"
#             ]
#         },
#         {
#             "Action": [
#                 "kms:Encrypt",
#                 "kms:Decrypt",
#                 "kms:GenerateDataKey*",
#                 "kms:DescribeKey"
#             ],
#             "Effect": "Allow",
#             "Resource": "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/24b0cd4f-3117-4e9b-ada8-fa46e7fd6d70"
#         }
#     ]
# }
# EOF
#
# }
#
# resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_basic_execution" {
#   provider   = aws.ENV_ACCT
#   role       = aws_iam_role.config_recorder_monitor_role[0].id
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
#
#
# data "archive_file" "config_recorder_monitor_zip" {
#   provider    = aws.ENV_ACCT
#   type        = "zip"
#   source_dir  = "${local.path_module}/lambda/config_monitor/code"
#   output_path = "${local.path_module}/lambda/config_monitor/package/lambda.zip"
# }
#
# resource "aws_lambda_function" "config_recorder_monitor" {
#   provider         = aws.ENV_ACCT
#   filename         = "${path.module}/lambda/config_monitor/package/lambda.zip"
#   function_name    = "${var.monitor_name}-${var.namespace}-lambda"
#   role             = aws_iam_role.config_recorder_monitor_role[0].arn
#   handler          = "config_monitor.lambda_handler"
#   source_code_hash = data.archive_file.config_recorder_monitor_zip.output_base64sha256
#   runtime          = "python3.7"
#   timeout          = "900"
#   memory_size      = "2048"
#
#   environment {
#     variables = {
#       bucket_name          = "${var.config_bucket}-${var.namespace}"
#       threashold_min       = var.monitor_lambda_run
#       path_config_recorder = var.config_recorder_file
#     }
#   }
#
#   tags = {
#     Name = "lambda-${var.config_name}-${var.namespace}"
#   }
#
#   # lifecycle {
#   #   ignore_changes = [
#   #     filename,
#   #     last_modified,
#   #     source_code_hash,
#   #   ]
#   # }
#
# }
#
# resource "aws_cloudwatch_log_group" "config_recorder_monitor" {
#   provider          = aws.ENV_ACCT
#   name              = "/aws/lambda/${aws_lambda_function.config_recorder_monitor.function_name}"
#   retention_in_days = 90
#
#   tags = {
#     Name = "log-lambda-${var.config_name}-${var.namespace}}"
#   }
# }
#
# resource "aws_iam_policy" "config_recorder_monitor_logging" {
#   provider    = aws.ENV_ACCT
#   name        = "${var.monitor_name}-${var.namespace}-lambda-logging"
#   path        = "/"
#   description = "IAM policy for monitor lambda"
#
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": [
#         "${aws_cloudwatch_log_group.config_recorder_monitor.arn}",
#         "${aws_cloudwatch_log_group.config_recorder_monitor.arn}/*"
#       ],
#       "Effect": "Allow"
#     },
#     {
#        "Action": "logs:CreateLogGroup",
#        "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
#        "Effect": "Allow"
#     }
#   ]
# }
# EOF
#
# }
#
# resource "aws_cloudwatch_event_rule" "config_recorder_monitor" {
#   provider            = aws.ENV_ACCT
#   name                = "${var.monitor_name}-${var.namespace}-cw-event-rule"
#   description         = "Alerts every hour between 12pm and 5pm"
#   schedule_expression = "cron(${var.monitor_lambda_run_schedule})"
#   is_enabled          = "true"
# }
#
# resource "aws_cloudwatch_event_target" "config_recorder_monitor" {
#   provider = aws.ENV_ACCT
#   rule     = aws_cloudwatch_event_rule.config_recorder_monitor.name
#   arn      = aws_lambda_function.config_recorder_monitor.arn
# }
#
# resource "aws_lambda_permission" "config_recorder_monitor_cw_permission" {
#   provider      = aws.ENV_ACCT
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.config_recorder_monitor.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.config_recorder_monitor.arn
# }
