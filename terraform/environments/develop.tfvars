# Project name
org = "helix" 

# Project name
project = "data_lake" 

# Environment name to be prefixed in resource names
environment = "dev" 

# AWS region name to be used for resource provisioning
region = "us-east-2"  

# VPC Internet Facing
main_vpc = "20.0.0.0/16"
apps_subnets  = ["20.0.1.0/24", "20.0.2.0/24"]
availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

# DHCP Uptions for VPC
domain_name          = "example.com"
domain_name_servers  = ["AmazonProvidedDNS"]
ntp_servers          = ["169.254.169.123"]

expiration_days = 10950
tmp_clean_days = 7
days_to_infreq = 90
days_to_glacier = 180
days_to_deep_achive = 365

# VPCs where our services reside
data_vpcs  = ["10.155.88.0/21", "10.155.96.0/21"]