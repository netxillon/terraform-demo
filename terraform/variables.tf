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

# Define variables for vpc

variable "demo_vpc" {
  type = string
  description = "CIDR block to be used for VPC, e.g. 10.5.0.0/16"
}

variable "public_availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the regions"
  default     = ["us-east-2a", "us-east-2b"]
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

variable "apps_subnets" {
  type = list(string)
  description = "List of subnets for the Redshift Cluster"
}

