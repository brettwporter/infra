<!-- BEGIN_TF_DOCS -->
Server Function

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_server_function_config"></a> [server\_function\_config](#input\_server\_function\_config) | Configuration for the server function | <pre>object({<br>    filename        = string<br>    function_name   = optional(string, "server")<br>    handler         = optional(string, "index.mjs")<br>    memory_size     = optional(number, 2048)<br>    runtime         = optional(string, "nodejs20.x")<br>    timeout         = optional(number, 10)<br>    tracing_enabled = optional(bool, true)<br>  })</pre> | n/a | yes |
| <a name="input_shared_tags"></a> [shared\_tags](#input\_shared\_tags) | Tags to be applied to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for the AWS networking | <pre>object({<br>    enabled            = optional(bool, false)<br>    subnet_ids         = optional(list(string), [])<br>    security_group_ids = optional(list(string), [])<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_server_function"></a> [server\_function](#output\_server\_function) | The server function attributes. Attributes are documented under the aws\_lambda\_function resource in the AWS Provider documentation. |
<!-- END_TF_DOCS -->