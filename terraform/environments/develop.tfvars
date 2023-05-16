# Project name
org = "helix" 

# Project name
project = "data_lake" 

# Environment name to be prefixed in resource names
environment = "dev" 

# AWS region name to be used for resource provisioning
region = "ap-southeast-2"  

# VPC Private
private_vpc = "10.168.88.0/21"
private_subnets_tgw  = ["10.168.88.0/28", "10.168.88.16/28","10.168.88.32/28"]
private_subnets_redshift  = ["10.168.88.112/28", "10.168.88.128/28"]
private_subnets_workload  = ["10.168.90.0/23", "10.168.92.0/23", "10.168.94.0/23"]
private_availability_zones = ["ap-southeast-2a", "ap-southeast-2b","ap-southeast-2c"]

# VPC Public
public_vpc = "192.168.1.0/24"
public_subnets_tgw  = ["192.168.1.0/28", "192.168.1.16/28"]
public_subnets_workload  = ["192.168.1.32/27", "192.168.1.64/27"]
public_availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

# DHCP Uptions for VPC
domain_name          = "example.com"
domain_name_servers  = ["AmazonProvidedDNS"]
ntp_servers          = ["169.254.169.123"]

expiration_days = 10950
tmp_clean_days = 75
days_to_infreq = 40
days_to_glacier = 180
days_to_deep_achive = 365

# Redshift
cluster_node_type        = "ra3.xlplus"
cluster_number_of_nodes  = "2"
automated_snapshot_retention_period = "3"