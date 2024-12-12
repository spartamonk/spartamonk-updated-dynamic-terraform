provider "aws" {
  profile = "default"
  region  = "us-east-1"
  default_tags {
    tags = {
      Owner       = "JJTech-model-batc"
      Environment = terraform.workspace
      IAC-managed = "true"
    }
  }
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}