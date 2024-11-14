terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
      configuration_aliases = [
        aws.iam
      ]
    }
  }
  backend "s3" {
    bucket = "eu-north-1-dev-video-test"
    key    = "junayed/terraform/states/lambda-to-quick-deploy"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}
provider "aws" {
  region = "eu-north-1"
  alias  = "iam"
}


module "lambda_to_quick_deploy" {
  source                = "./terraform"
   providers = {
    aws             = aws
    aws.iam         = aws.iam
  }
}