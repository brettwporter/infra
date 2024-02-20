/**
 * Server Function
 ***/

variable "server_function_config" {
  description = "Configuration for the server function"
  type = object({
    filename        = string
    function_name   = optional(string, "server")
    handler         = optional(string, "index.mjs")
    memory_size     = optional(number, 2048)
    runtime         = optional(string, "nodejs20.x")
    timeout         = optional(number, 10)
    tracing_enabled = optional(bool, true)
  })
}

/**
 * Image Optimization Function
 ***/

variable "image_optimization_function_config" {
  description = "Configuration for the image optimization function"
  type = object({
    filename        = string
    function_name   = optional(string, "image-optimization")
    handler         = optional(string, "index.mjs")
    memory_size     = optional(number, 2048)
    runtime         = optional(string, "nodejs20.x")
    timeout         = optional(number, 10)
    tracing_enabled = optional(bool, true)
  })
}

/**
 * Asset Files Bucket
 ***/

variable "asset_bucket_config" {
  description = "Configuration for the asset files bucket"
  type = object({
    bucket_name = optional(string, "asset-files")
  })
  default = {
    bucket_name = "asset-files"
  }
}

/**
 * Revalidation Function
 ***/

variable "revalidation_function_config" {
  description = "Configuration for the revalidation function"
  type = object({
    filename        = string
    function_name   = optional(string, "revalidation")
    handler         = optional(string, "index.mjs")
    memory_size     = optional(number, 2048)
    runtime         = optional(string, "nodejs20.x")
    timeout         = optional(number, 10)
    tracing_enabled = optional(bool, true)
  })
}

/**
 * Cache Files Bucket
 ***/

variable "cache_bucket_config" {
  description = "Configuration for the cache files bucket"
  type = object({
    bucket_name = optional(string, "cache-files")
  })
  default = {
    bucket_name = "cache-files"
  }
}

/**
 * Revalidation Tag-to-path Mapping DynamoDB Table
 ***/

variable "revalidation_tag_to_path_mapping_dynamodb_table_config" {
  description = "Configuration for the revalidation table"
  type = object({
    table_name = optional(string, "revalidation")
  })
  default = {
    table_name = "revalidation"
  }
}

/**
 * Warmer Function
 ***/

variable "warmer_function_config" {
  description = "Configuration for the warmer function"
  type = object({
    filename        = string
    function_name   = optional(string, "warmer")
    handler         = optional(string, "index.mjs")
    memory_size     = optional(number, 2048)
    runtime         = optional(string, "nodejs20.x")
    timeout         = optional(number, 10)
    tracing_enabled = optional(bool, true)
    concurrency     = optional(number, 1)
  })
}

/**
 * Warmer Eventbridge Cron Event
 ***/

variable "warmer_cron_eventbridge_event_rule_config" {
  description = "Configuration for the warmer cron eventbridge event rule"
  type = object({
    name                = optional(string, "warmer")
    schedule_expression = optional(string, "rate(5 minutes)")
  })
  default = {
    name                = "warmer"
    schedule_expression = "rate(5 minutes)"
  }
}

/**
 * Networking
 ***/

variable "vpc_config" {
  description = "Configuration for the AWS networking"
  type = object({
    enabled            = optional(bool, false)
    subnet_ids         = optional(list(string), [])
    security_group_ids = optional(list(string), [])
  })
  default = {
    enabled            = false
    subnet_ids         = []
    security_group_ids = []
  }
}

/**
 * Tags
 ***/

variable "shared_tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
