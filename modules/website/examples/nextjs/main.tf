/**
 * Basic example of using the module to deploy a Next.js application.
 ##*/

module "website" {
  source = "../../"

  server_function_config = {
    filename = "server.zip"
  }

  image_optimization_function_config = {
    filename = "image-optimization.zip"
  }

  revlidation_function_config = {
    filename = "revlidation.zip"
  }
  
  warmer_function_config = {
    filename = "warmer.zip"
  }
}
