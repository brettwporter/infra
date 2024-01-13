<!-- BEGIN_TF_DOCS -->
Server Function
***/

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
| [aws_iam_role.image_optimization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.revalidation_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.server_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.warmer_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.image_optimization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.revalidation_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.server_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.warmer_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_event_source_mapping.revalidation_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.image_optimization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.revalidation_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.warmer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_sqs_queue.revalidation_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_optimization_function_config"></a> [image\_optimization\_function\_config](#input\_image\_optimization\_function\_config) | Configuration for the image optimization function | <pre>object({<br>    filename        = string<br>    function_name   = optional(string, "image-optimization")<br>    handler         = optional(string, "index.mjs")<br>    memory_size     = optional(number, 2048)<br>    runtime         = optional(string, "nodejs20.x")<br>    timeout         = optional(number, 10)<br>    tracing_enabled = optional(bool, true)<br>  })</pre> | n/a | yes |
| <a name="input_revlidation_function_config"></a> [revlidation\_function\_config](#input\_revlidation\_function\_config) | Configuration for the revalidation function | <pre>object({<br>    filename        = string<br>    function_name   = optional(string, "revalidation")<br>    handler         = optional(string, "index.mjs")<br>    memory_size     = optional(number, 2048)<br>    runtime         = optional(string, "nodejs20.x")<br>    timeout         = optional(number, 10)<br>    tracing_enabled = optional(bool, true)<br>  })</pre> | n/a | yes |
| <a name="input_server_function_config"></a> [server\_function\_config](#input\_server\_function\_config) | Configuration for the server function | <pre>object({<br>    filename        = string<br>    function_name   = optional(string, "server")<br>    handler         = optional(string, "index.mjs")<br>    memory_size     = optional(number, 2048)<br>    runtime         = optional(string, "nodejs20.x")<br>    timeout         = optional(number, 10)<br>    tracing_enabled = optional(bool, true)<br>  })</pre> | n/a | yes |
| <a name="input_shared_tags"></a> [shared\_tags](#input\_shared\_tags) | Tags to be applied to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for the AWS networking | <pre>object({<br>    enabled            = optional(bool, false)<br>    subnet_ids         = optional(list(string), [])<br>    security_group_ids = optional(list(string), [])<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "security_group_ids": [],<br>  "subnet_ids": []<br>}</pre> | no |
| <a name="input_warmer_function_config"></a> [warmer\_function\_config](#input\_warmer\_function\_config) | Configuration for the warmer function | <pre>object({<br>    filename        = string<br>    function_name   = optional(string, "warmer")<br>    handler         = optional(string, "index.mjs")<br>    memory_size     = optional(number, 2048)<br>    runtime         = optional(string, "nodejs20.x")<br>    timeout         = optional(number, 10)<br>    tracing_enabled = optional(bool, true)<br>    concurrency     = optional(number, 1)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_image_optimization_function"></a> [image\_optimization\_function](#output\_image\_optimization\_function) | The image optimization function attributes. Attributes are documented under the aws\_lambda\_function resource in the AWS Provider documentation. |
| <a name="output_revalidation_function"></a> [revalidation\_function](#output\_revalidation\_function) | The revalidation function attributes. Attributes are documented under the aws\_lambda\_function resource in the AWS Provider documentation. |
| <a name="output_revalidation_queue"></a> [revalidation\_queue](#output\_revalidation\_queue) | The revalidation queue attributes. Attributes are documented under the aws\_sqs\_queue resource in the AWS Provider documentation. |
| <a name="output_server_function"></a> [server\_function](#output\_server\_function) | The server function attributes. Attributes are documented under the aws\_lambda\_function resource in the AWS Provider documentation. |
<!-- END_TF_DOCS -->