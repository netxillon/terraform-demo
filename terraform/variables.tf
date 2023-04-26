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
## Define S3 life Cycle Policy variables

variable "expiration_days" {
  type = number
  description = "This defines the days after which the object will be deleted"
}

variable "tmp_clean_days" {
  type = number
  description = "This defines the days after which the object will be deleted"
}

variable "days_to_infreq" {
  type = number
  description = "This defines the number of days after which object will be moved to STANDARD_IA"
}

variable "days_to_glacier" {
  type = string
  description = "This defines the number of days after which object will be moved to GLACIER"
}

variable "days_to_deep_achive" {
  type = string
  description = "This defines the number of days after which object will be moved to DEEP ARCHIVE"
}

variable "data_vpcs" {
    description = "The IP of dbt servers"
    type        = list(string)
}