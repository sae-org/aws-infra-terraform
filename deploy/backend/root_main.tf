# calling the aws provider from TF registry 
terraform {
  backend "s3" {

    bucket = "dev-sae-tf-backend"
    key = "terraform/backend/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    # profile = "dev"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# configuring aws provider 
provider "aws" {
  region = "us-east-1"
  # profile = "dev"
}

module "backend" {
  source = "../../modules/backend"
  # /Users/saeeda/devops/terraform/deploy/backend/root_main.tf
  # /Users/saeeda/devops/terraform/modules/backend
}