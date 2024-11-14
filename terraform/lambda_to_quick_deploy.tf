locals {
  lambda_to_quick_deploy_name = "lambda_to_quick_deploy"
}
data "aws_iam_policy_document" "lambda_to_quick_deploy_policy_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "lambda_to_quick_deploy_role" {
  provider           = aws.iam
  name               = local.lambda_to_quick_deploy_name
  assume_role_policy = data.aws_iam_policy_document.lambda_to_quick_deploy_policy_document.json
}

resource "aws_lambda_function" "lambda_to_quick_deploy" {
  function_name    = local.lambda_to_quick_deploy_name
  handler          = "index.handler"
  runtime          = var.lambda_runtime
  role             = aws_iam_role.lambda_to_quick_deploy_role.arn
  source_code_hash = filebase64sha256("${path.module}/zipped-lambdas/${local.lambda_to_quick_deploy_name}.zip")
  filename         = "${path.module}/zipped-lambdas/${local.lambda_to_quick_deploy_name}.zip"
  timeout          = var.lambda_timeout
  architectures    = [ var.lambda_architecture]
  
  environment {
    variables = {
      
    }
  }
}
resource "aws_cloudwatch_log_group" "lambda_to_quick_deploy_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_to_quick_deploy.function_name}"
  retention_in_days = 30
}
data "aws_iam_policy_document" "lambda_to_quick_deploy_policy_document_cwLogs" {
  provider = aws.iam
  version  = "2012-10-17"

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}
resource "aws_iam_policy" "lambda_to_quick_deploy_policy_cwLogs" {
  provider = aws.iam
  name     = "${local.lambda_to_quick_deploy_name}_lambda_policy_cwLogs"
  policy   = data.aws_iam_policy_document.lambda_to_quick_deploy_policy_document_cwLogs.json
}
resource "aws_iam_role_policy_attachment" "lambda_to_quick_deploy_policy_attachment_cwLogs" {
  provider   = aws.iam
  role       = aws_iam_role.lambda_to_quick_deploy_role.name
  policy_arn = aws_iam_policy.lambda_to_quick_deploy_policy_cwLogs.arn
}

#extra added
data "aws_iam_policy_document" "lambda_to_quick_deploy_policy_document_cloudfront" {
  provider = aws.iam
  version  = "2012-10-17"

  statement {
    effect = "Allow"

    actions = [
      "cloudfront:ListCachePolicies",
    ]
    resources = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:cache-policy/*"]
  }
}
resource "aws_iam_policy" "lambda_to_quick_deploy_policy_cloudfront" {
  provider = aws.iam
  name     = "${local.lambda_to_quick_deploy_name}_lambda_policy_cloudfront"
  policy   = data.aws_iam_policy_document.lambda_to_quick_deploy_policy_document_cloudfront.json
}
resource "aws_iam_role_policy_attachment" "lambda_to_quick_deploy_policy_attachment_cloudfront" {
  provider   = aws.iam
  role       = aws_iam_role.lambda_to_quick_deploy_role.name
  policy_arn = aws_iam_policy.lambda_to_quick_deploy_policy_cloudfront.arn
}

#extra added

resource "aws_lambda_function_url" "lambda_to_quick_deploy_url" {
  function_name      = aws_lambda_function.lambda_to_quick_deploy.function_name
  authorization_type = "NONE"
  cors {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}