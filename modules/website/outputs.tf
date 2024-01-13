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