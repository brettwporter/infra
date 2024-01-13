/**
 * Server Function
 ***/

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

resource "aws_iam_role" "server_lambda" {
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

resource "aws_iam_role_policy" "server_lambda" {
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
        Resource = aws_sqs_queue.revalidation_queue.arn
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
  role = aws_iam_role.server_lambda.id
}

/**
 * Image Optimization Function
 ***/

resource "aws_lambda_function" "image_optimization" {
  architectures    = ["arm64"]
  description      = "Image Optimization function for the website"
  filename         = var.image_optimization_function_config.filename
  function_name    = var.image_optimization_function_config.function_name
  handler          = var.image_optimization_function_config.handler
  memory_size      = var.image_optimization_function_config.memory_size
  role             = aws_iam_role.image_optimization.arn
  runtime          = var.image_optimization_function_config.runtime
  source_code_hash = filebase64sha256(var.image_optimization_function_config.filename)
  timeout          = var.image_optimization_function_config.timeout

  dynamic "tracing_config" {
    for_each = var.image_optimization_function_config.tracing_enabled ? [1] : []

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
      BUCKET_NAME       = "INSERT_ASSET_BUCKET_NAME_HERE"
      BUCKET_KEY_PREFIX = "INSERT_ASSET_BUCKET_KEY_PREFIX_HERE (Optional)"
    }
  }

  tags = merge(var.shared_tags, {
    Name = var.image_optimization_function_config.function_name
  })
}

resource "aws_iam_role" "image_optimization" {
  name = var.image_optimization_function_config.function_name
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

resource "aws_iam_role_policy" "image_optimization" {
  name = var.image_optimization_function_config.function_name
  policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "INSERT ASSET S3 BUCKET ARN"
      }
    ]
  })
  role = aws_iam_role.image_optimization.id
}

/**
 * Asset Files Bucket
 ***/

/**
 * Revalidation Function
 ***/

resource "aws_lambda_function" "revalidation_function" {
  description      = "Revalidation function for the website"
  filename         = var.revalidation_function_config.filename
  function_name    = var.revalidation_function_config.function_name
  handler          = var.revalidation_function_config.handler
  memory_size      = var.revalidation_function_config.memory_size
  role             = aws_iam_role.revalidation_function.arn
  runtime          = var.revalidation_function_config.runtime
  source_code_hash = filebase64sha256(var.revalidation_function_config.filename)
  timeout          = var.revalidation_function_config.timeout

  dynamic "tracing_config" {
    for_each = var.revalidation_function_config.tracing_enabled ? [1] : []

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
      BUCKET_NAME       = "INSERT_ASSET_BUCKET_NAME_HERE"
      BUCKET_KEY_PREFIX = "INSERT_ASSET_BUCKET_KEY_PREFIX_HERE (Optional)"
    }
  }

  tags = merge(var.shared_tags, {
    Name = var.revalidation_function_config.function_name
  })
}

resource "aws_iam_role" "revalidation_function" {
  name = var.revalidation_function_config.function_name
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

resource "aws_iam_role_policy" "revalidation_function" {
  name = var.revalidation_function_config.function_name
  role = aws_iam_role.revalidation_function.id
  policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ],
        Effect = "Allow",
        Resource = aws_sqs_queue.revalidation_queue.arn
      }
    ]
  })
}

resource "aws_lambda_event_source_mapping" "revalidation_queue" {
  event_source_arn = aws_sqs_queue.revalidation_queue.arn
  function_name    = aws_lambda_function.revalidation_function.function_name
}


/**
 * Revalidation Queue
 ***/

resource "aws_sqs_queue" "revalidation_queue" {
  name = "revalidation-queue.fifo"
  fifo_queue = true

  tags = merge(var.shared_tags, {
    Name = "revalidation-queue.fifo"
  })
}

/**
 * Revalidation Tag-to-path Mapping DynamoDB Table
 ***/

/**
 * Cache Files Bucket
 ***/

/**
 * Warmer Function
 ***/

/**
 * Warmer Eventbridge Cron
 ***/
