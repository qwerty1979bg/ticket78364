terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

provider "aws" {
 region = "us-east-1"
}

module "lambda_function_existing_package_local" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "filipd-test-ticket78364-local"
  description   = "filipd test ticket78364"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package         = false
  local_existing_package = local_file.foo.filename
}
  
resource "local_file" "foo" {
    source  = data.archive_file.periodically_invalidate_cache.output_path
    filename = "${data.archive_file.periodically_invalidate_cache.output_sha}-${data.archive_file.periodically_invalidate_cache.output_path}"

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      all
    ]
  }
}

  
}  
  
output "test1" {
  value=data.archive_file.periodically_invalidate_cache
}
  
#output "test2" {
#  value=nonsensitive(local_file.foo)
#  value=local_file.foo
#}
  
data "archive_file" "periodically_invalidate_cache" {
type = "zip"
source_dir = "test"
output_path = "test.zip"
}

