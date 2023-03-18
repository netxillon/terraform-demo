variable "org" {
  type = string
  description = "Organization name"
}

variable "project" {
  type = string
  description = "Project name"
}

variable "region" {
  type = string
  description = "AWS Region"
}

variable "environment" {
  type = string
  description = "Environment name to be prefixed in resource names"
}

variable "AWS_DEFAULT_REGION" {
  type = string
  description = "The region to provison the resources in"
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
  description = "AWS Access key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  description = "AWS Secret Access key"
}

variable "s3_encrypt" {
  type = list
  default = [{
    apply_server_side_encryption_by_default = [{
      sse_algorithm     = "AES256"
      }]
  }]
}