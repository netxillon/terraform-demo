terraform {
  cloud {}  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60.0"
    }
  }
}

provider "aws" {
  region     = "${var.AWS_DEFAULT_REGION}"
  access_key = "${var.AWS_ACCESS_KEY_ID}"
  secret_key = "${var.AWS_SECRET_ACCESS_KEY}"
  default_tags {
    tags = {
      Project     = "${var.project}"
      Environment = "${var.environment}"
      CreatedBy   = "Terraform"
      Contact = "gurmukh singh"
      Component = "Base Platform"
    }
  }
}