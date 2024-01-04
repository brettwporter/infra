/**
 * Basic example of using the module to deploy a Next.js application.
 ##*/

module "website" {
  source = "../../"

  server_function_config = {
    filename = "server.zip"
  }
}
