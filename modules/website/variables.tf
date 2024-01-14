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
 * Revalidation Function
 ***/
 
variable "revlidation_function_config" {
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
