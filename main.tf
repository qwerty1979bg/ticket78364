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
  local_existing_package = "${data.archive_file.periodically_invalidate_cache.output_path}-${data.archive_file.periodically_invalidate_cache.output_sha}"
}
  
output "test1" {
  value=data.archive_file.periodically_invalidate_cache
}
  
output "test2" {
  value=data.archive_file.periodically_invalidate_cache.output_base64sha256
}
  
data "archive_file" "periodically_invalidate_cache" {
type = "zip"
source_dir = "test"
output_path = "test.zip"
}

