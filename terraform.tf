terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"

    }
  }
  backend "s3" {
    encrypt        = true
  }
}
