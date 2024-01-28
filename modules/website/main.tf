/**
 * Common Data Sources
 ***/

data "aws_region" "current" {}

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
      CACHE_BUCKET_NAME         = aws_s3_bucket.cache_bucket.id
      CACHE_BUCKET_REGION       = data.aws_region.current.name
      CACHE_DYNAMO_TABLE        = aws_dynamodb_table.revalidation_tag_to_path_mapping.id
      REVALIDATION_QUEUE_URL    = aws_sqs_queue.revalidation_queue.id
      REVALIDATION_QUEUE_REGION = data.aws_region.current.name
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
        Resource = "${aws_s3_bucket.cache_bucket.arn}/*"
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
        Resource = aws_dynamodb_table.revalidation_tag_to_path_mapping.arn
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
      BUCKET_NAME = aws_s3_bucket.asset_files_bucket.id
    }
  }

  tags = merge(var.shared_tags, {
    Name = var.image_optimization_function_config.function_name
  })
}

resource "aws_lambda_function_url" "image_optimization" {
  function_name      = aws_lambda_function.image_optimization.function_name
  authorization_type = "NONE"
  invoke_mode        = "BUFFERED"
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
        Resource = "${aws_s3_bucket.asset_files_bucket.arn}/*"
      }
    ]
  })
  role = aws_iam_role.image_optimization.id
}

/**
 * Asset Files Bucket
 ***/

resource "aws_s3_bucket" "asset_bucket" {
  bucket = var.asset_bucket_config.bucket_name

  tags = merge(var.shared_tags, {
    Name = var.asset_bucket_config.bucket_name
  })
}

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
        Effect   = "Allow",
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
  name       = "revalidation-queue.fifo"
  fifo_queue = true

  tags = merge(var.shared_tags, {
    Name = "revalidation-queue.fifo"
  })
}

/**
 * Revalidation Tag-to-path Mapping DynamoDB Table
 ***/

resource "aws_dynamodb_table" "revalidation_tag_to_path_mapping" {
  name = var.revalidation_tag_to_path_mapping_dynamodb_table_config.table_name

  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "tag"
  range_key    = "path"

  attribute {
    name = "tag"
    type = "S"
  }

  attribute {
    name = "path"
    type = "S"
  }

  attribute {
    name = "revalidatedAt"
    type = "N"
  }

  global_secondary_index {
    name            = "revalidate"
    hash_key        = "path"
    range_key       = "revalidatedAt"
    projection_type = "KEYS_ONLY"
  }

  tags = merge(var.shared_tags, {
    Name = var.revalidation_tag_to_path_mapping_dynamodb_table_config.table_name
  })
}

/**
 * Cache Files Bucket
 ***/

resource "aws_s3_bucket" "cache_bucket" {
  bucket = var.cache_bucket_config.bucket_name

  tags = merge(var.shared_tags, {
    Name = var.cache_bucket_config.bucket_name
  })
}

/**
 * Warmer Function
 ***/

resource "aws_lambda_function" "warmer" {
  description      = "Warmer function for the website"
  filename         = var.warmer_function_config.filename
  function_name    = var.warmer_function_config.function_name
  handler          = var.warmer_function_config.handler
  memory_size      = var.warmer_function_config.memory_size
  role             = aws_iam_role.warmer.arn
  runtime          = var.warmer_function_config.runtime
  source_code_hash = filebase64sha256(var.warmer_function_config.filename)
  timeout          = var.warmer_function_config.timeout

  dynamic "tracing_config" {
    for_each = var.warmer_function_config.tracing_enabled ? [1] : []

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
      FUNCTION_NAME = var.server_function_config.function_name
      CONCURRENCY   = var.warmer_function_config.concurrency
    }
  }

  tags = merge(var.shared_tags, {
    Name = var.warmer_function_config.function_name
  })
}

resource "aws_lambda_function_url" "server" {
  function_name      = aws_lambda_function.server.function_name
  authorization_type = "NONE"
  invoke_mode        = "BUFFERED"
}

resource "aws_iam_role" "warmer_lambda" {
  name = var.warmer_function_config.function_name
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

resource "aws_iam_role_policy" "warmer_lambda" {
  name = var.warmer_function_config.function_name
  policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ]
        Effect   = "Allow"
        Resource = aws_lambda_function.server.arn
      }
    ]
  })
  role = aws_iam_role.warmer_lambda.id
}

/**
 * Warmer Eventbridge Cron
 ***/

resource "aws_cloudwatch_event_rule" "warmer_eventbridge_cron" {
  name                = var.warmer_eventbridge_cron_config.name
  schedule_expression = var.warmer_eventbridge_cron_config.schedule_expression
}

resource "aws_cloudwatch_event_target" "warmer_eventbridge_cron_target" {
  arn  = aws_lambda_function.warmer.arn
  rule = aws_cloudwatch_event_rule.scheduled_lambda_event_rule.name
}

/**
 * CloudFront Distribution
 ***/

resource "aws_cloudfront_function" "host_header_function" {
  name    = "host-header-function"
  runtime = "cloudfront-js-1.0"
  comment = "Next.js Function for Preserving Original Host"
  publish = true
  code    = file("${path.module}/resources/host-header-function.js")
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "Origin Access Identity for the Next.js website"
}

resource "aws_cloudfront_distribution" "this" {
  comment = "Distribution for the Next.js website"
  enabled = true

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # S3 Bucket Origin
  origin {
    domain_name = aws_s3_bucket.asset_files_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.asset_files_bucket.id
    origin_path = "/assets"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  # Server Function Origin
  origin {
    domain_name = aws_lambda_function_url.server_function.function_url
    origin_id   = aws_lambda_function.server.function_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Image Optimization Function Origin
  origin {
    domain_name = aws_lambda_function_url.image_optimization.function_url
    origin_id   = aws_lambda_function.image_optimization.function_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/_next/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.asset_files_bucket.Identity

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 2
  ordered_cache_behavior {
    path_pattern     = "/favicon.ico"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.asset_files_bucket.Identity

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 3
  ordered_cache_behavior {
    path_pattern     = "/my-images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lambda_function.image_optimization.function_name

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 4
  ordered_cache_behavior {
    path_pattern     = "/_next/image"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lambda_function.server.function_name

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 5
  ordered_cache_behavior {
    path_pattern     = "/_next/data/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lambda_function.server.function_name

    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.host_header_function.arn
    }
  }

  # Cache behavior with precedence 6
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lambda_function.server.function_name

    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.host_header_function.arn
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lambda_function.server.function_name


    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.host_header_function.arn
    }
  }
}

