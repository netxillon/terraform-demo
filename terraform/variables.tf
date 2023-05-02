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
# VPC
variable "main_vpc" {
  type = string
  description = "CIDR block to be used for VPC, e.g. 10.5.0.0/16"
}

variable "apps_subnets" {
  type = list(string)
  description = "List of subnets for the workloads"
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "domain_name" {
  description = "Domain name"
}

variable "domain_name_servers" {
  description = "List of DNS Servers"
}

variable "ntp_servers" {
  description = "List of NTP Servers"
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