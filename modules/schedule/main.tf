

resource "aws_iam_role" "ec2_scheduler_role" {
  name = "ec2-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_scheduler_policy" {
  name = "ec2-scheduler-policy"
  role = aws_iam_role.ec2_scheduler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

# Lambda function to stop EC2 at 18:00 (6 PM)
resource "aws_lambda_function" "ec2_stop" {
  count         = var.enable_schedule ? 1 : 0
  filename      = "stop_ec2.zip"
  function_name = "stop-ec2-${var.instance_id}"
  role          = aws_iam_role.ec2_scheduler_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }
}

# Lambda function to start EC2 at 00:00 (midnight)
resource "aws_lambda_function" "ec2_start" {
  count         = var.enable_schedule ? 1 : 0
  filename      = "start_ec2.zip"
  function_name = "start-ec2-${var.instance_id}"
  role          = aws_iam_role.ec2_scheduler_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }
}

# EventBridge rule - Stop EC2 at 18:00 UTC (6 PM)
resource "aws_cloudwatch_event_rule" "stop_ec2" {
  count               = var.enable_schedule ? 1 : 0
  name                = "stop-ec2-${var.instance_id}"
  description         = "Stop EC2 instance at 18:00 UTC daily"
  schedule_expression = var.stop_schedule  # "cron(0 18 * * ? *)"
}

# EventBridge rule - Start EC2 at 00:00 UTC (midnight)
resource "aws_cloudwatch_event_rule" "start_ec2" {
  count               = var.enable_schedule ? 1 : 0
  name                = "start-ec2-${var.instance_id}"
  description         = "Start EC2 instance at 00:00 UTC daily"
  schedule_expression = var.start_schedule  # "cron(0 0 * * ? *)"
}

# EventBridge targets
resource "aws_cloudwatch_event_target" "stop_target" {
  count     = var.enable_schedule ? 1 : 0
  rule      = aws_cloudwatch_event_rule.stop_ec2[0].name
  target_id = "StopEC2Target"
  arn       = aws_lambda_function.ec2_stop[0].arn
}

resource "aws_cloudwatch_event_target" "start_target" {
  count     = var.enable_schedule ? 1 : 0
  rule      = aws_cloudwatch_event_rule.start_ec2[0].name
  target_id = "StartEC2Target"
  arn       = aws_lambda_function.ec2_start[0].arn
}

# Lambda permissions
resource "aws_lambda_permission" "allow_eventbridge_stop" {
  count         = var.enable_schedule ? 1 : 0
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_stop[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_ec2[0].arn
}

resource "aws_lambda_permission" "allow_eventbridge_start" {
  count         = var.enable_schedule ? 1 : 0
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_start[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_ec2[0].arn
}