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
