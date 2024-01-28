/**
 * Server Function
 ***/

output "server_function" {
  description = "The server function attributes. Attributes are documented under the aws_lambda_function resource in the AWS Provider documentation."
  value       = aws_lambda_function.server_function
}

/**
 * Image Optimization Function
 ***/

output "image_optimization_function" {
  description = "The image optimization function attributes. Attributes are documented under the aws_lambda_function resource in the AWS Provider documentation."
  value       = aws_lambda_function.image_optimization
}

/**
 * Asset Files Bucket
 ***/

output "asset_bucket" {
  description = "The asset files bucket attributes. Attributes are documented under the aws_s3_bucket resource in the AWS Provider documentation."
  value       = aws_s3_bucket.asset_bucket
}

/**
 * Revalidation Function
 ***/

output "revalidation_function" {
  description = "The revalidation function attributes. Attributes are documented under the aws_lambda_function resource in the AWS Provider documentation."
  value       = aws_lambda_function.revalidation
}

/**
 * Revalidation Queue
 ***/

output "revalidation_queue" {
  description = "The revalidation queue attributes. Attributes are documented under the aws_sqs_queue resource in the AWS Provider documentation."
  value       = aws_sqs_queue.revalidation_queue
}

/**
 * Revalidation Tag-to-path Mapping DynamoDB Table
 ***/

output "revalidation_table" {
  description = "The revalidation tag-to-path mapping DynamoDB table attributes. Attributes are documented under the aws_dynamodb_table resource in the AWS Provider documentation."
  value       = aws_dynamodb_table.revalidation_table
}

/**
 * Cache Files Bucket
 ***/

output "cache_bucket" {
  description = "The cache files bucket attributes. Attributes are documented under the aws_s3_bucket resource in the AWS Provider documentation."
  value       = aws_s3_bucket.cache_bucket
}

/**
 * Warmer Function
 ***/

output "warmer_function" {
  description = "The warmer function attributes. Attributes are documented under the aws_lambda_function resource in the AWS Provider documentation."
  value       = aws_lambda_function.warmer
}

/**
 * Warmer Eventbridge Cron
 ***/

output "warmer_eventbridge_cron" {
  description = "The warmer eventbridge cron attributes. Attributes are documented under the aws_cloudwatch_event_rule resource in the AWS Provider documentation."
  value       = aws_cloudwatch_event_rule.warmer
}

/**
 * Revalidation Queue
 ***/

output "revalidation_queue" {
  description = "The revalidation queue attributes. Attributes are documented under the aws_sqs_queue resource in the AWS Provider documentation."
  value       = aws_sqs_queue.revalidation_queue
}
