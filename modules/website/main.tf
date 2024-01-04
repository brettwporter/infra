/**
 * Server Function
 ##*/

resource "aws_lambda_function" "server" {
  description      = "Server function for the website"
  filename         = var.server_function_config.filename
  function_name    = var.server_function_config.function_name
  handler          = var.server_function_config.handler
  memory_size      = var.server_function_config.memory_size
  role             = aws_iam_role.server.arn
  runtime          = var.server_function_config.runtime
  source_code_hash = filebase64sha256(var.server_function_config.filename)
  timeout          = var.server_function_config.timeout

  dynamic "tracing_config" {
    for_each = var.server_function_config.tracing_enabled ? [1] : []

    content {
      mode = "Active"
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config.enabled ? [1] : []

    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = var.vpc_config.security_group_ids
    }
  }

  environment {
    variables = {
      CACHE_BUCKET_NAME         = "INSERT_CACHE_BUCKET_NAME_HERE"
      CACHE_BUCKET_KEY_PREFIX   = "INSERT_CACHE_BUCKET_KEY_PREFIX_HERE"
      CACHE_BUCKET_REGION       = "INSERT_CACHE_BUCKET_REGION_HERE"
      CACHE_DYNAMO_TABLE        = "INSERT_CACHE_DYNAMO_TABLE_HERE"
      REVALIDATION_QUEUE_URL    = "INSERT_REVALIDATION_QUEUE_URL_HERE"
      REVALIDATION_QUEUE_REGION = "INSERT_REVALIDATION_QUEUE_REGION_HERE"
    }
  }

  tags = merge(var.shared_tags, {
    Name = var.server_function_config.function_name
  })
}

resource "aws_iam_role" "server" {
  name = var.server_function_config.function_name
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

resource "aws_iam_role_policy" "server" {
  name = var.server_function_config.function_name
  policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "INSERT CACHE S3 BUCKET ARNS"
      },
      {
        Action = [
          "sqs:SendMessage"
        ]
        Effect   = "Allow"
        Resource = "INSERT REVALIDATION QUEUE ARNS"
      },
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ]
        Effect   = "Allow"
        Resource = "INSERT CACHE DYNAMO TABLE ARNS"
      }
    ]
  })
  role = aws_iam_role.server.id
}

/**
 * Image Optimization Function
 ##*/

/**
 * Asset Files Bucket
 ##*/

/**
 * Revalidation Function
 ##*/

/**
 * Revalidation Queue
 ##*/

/**
 * Revalidation Tag-to-path Mapping DynamoDB Table
 ##*/

/**
 * Cache Files Bucket
 ##*/

/**
 * Warmer Eventbridge Cron
 ##*/

/**
 * Warmer Function
 ##*/
