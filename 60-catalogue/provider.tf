terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.19.0"
    }
  }

  backend "s3" {
    bucket       = "84s-demo-remotest-comp"
    #bucket       = "84s-demo-remotest"
    key          = "roboshop-dev-catalogue"
    #key          = "roboshop-dev-backend-alb"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
