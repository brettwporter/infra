/**
 * Basic example of using the module to deploy a Next.js application.
 ##*/

module "website" {
  source = "../../../modules/website/nextjs"

  server_function_config = {
    filename = "server-function.zip"
  }

  image_optimization_function_config = {
    filename = "image-optimization-function.zip"
  }

  revalidation_function_config = {
    filename = "revalidation-function.zip"
  }

  warmer_function_config = {
    filename = "warmer-function.zip"
  }
}
