provider "aws" {
  region = "us-east-1"  
}

# IAM Role for Config
resource "aws_iam_role" "config_role" {
  name = "config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })

  // Attach policies for AWS Config
}

# Config Rule for Tag Enforcement
resource "aws_config_config_rule" "tag_enforcement_rule" {
  name = "tag-enforcement-rule"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  # Set up parameters for required tags
}

# SNS Topic for Notifications
resource "aws_sns_topic" "tag_notification" {
  name = "tag-notification-topic"
}

# SNS Topic Subscription for Config Notifications
resource "aws_config_configuration_recorder" "recorder" {
  name     = "default"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported       = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "channel" {
  s3_bucket_name = "your-s3-bucket-name" // replace with s3 bucket 
  sns_topic_arn  = aws_sns_topic.tag_notification.arn
}

# Lambda Function for Config Notifications
resource "aws_lambda_function" "config_notification_lambda" {
  function_name    = "config-notification-lambda"
  filename         = "lambda_function.zip"  # Path to your Lambda function code ZIP file
  handler          = "lambda_function.handler"
  runtime          = "python3.8"
  role             = aws_iam_role.config_role.arn

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.tag_notification.arn
    }
  }
}

# SNS Topic Subscription for Lambda
resource "aws_lambda_permission" "sns_permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.config_notification_lambda.function_name
  principal     = "sns.amazonaws.com"

  source_arn = aws_sns_topic.tag_notification.arn
}
