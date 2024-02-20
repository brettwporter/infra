/**
 * Server Function
 ***/

output "server_function" {
  description = "The server function attributes. Attributes are documented under the aws_lambda_function resource in the AWS Provider documentation."
  value       = aws_lambda_function.server
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

output "asset_files_bucket" {
  description = "The asset files bucket attributes. Attributes are documented under the aws_s3_bucket resource in the AWS Provider documentation."
  value       = aws_s3_bucket.asset_files
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

output "revalidation_tag_to_path_mapping_table" {
  description = "The revalidation tag-to-path mapping DynamoDB table attributes. Attributes are documented under the aws_dynamodb_table resource in the AWS Provider documentation."
  value       = aws_dynamodb_table.revalidation_tag_to_path_mapping
}

/**
 * Cache Files Bucket
 ***/

output "cache_bucket" {
  description = "The cache files bucket attributes. Attributes are documented under the aws_s3_bucket resource in the AWS Provider documentation."
  value       = aws_s3_bucket.cache
}

/**
 * Warmer Function
 ***/

output "warmer_function" {
  description = "The warmer function attributes. Attributes are documented under the aws_lambda_function resource in the AWS Provider documentation."
  value       = aws_lambda_function.warmer
}

/**
 * Warmer Eventbridge Cron Event
 ***/

output "warmer_cron_eventbridge_event_rule" {
  description = "The warmer eventbridge cron event attributes. Attributes are documented under the aws_cloudwatch_event_rule resource in the AWS Provider documentation."
  value       = aws_cloudwatch_event_rule.warmer_cron
}
