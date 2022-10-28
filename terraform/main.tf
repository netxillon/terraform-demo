resource "aws_vpc" "apps_vpc" {
  cidr_block           = var.demo_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-apps-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.apps_vpc.id

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-vpc-gw"
  }
}

resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name          = var.domain_name
  domain_name_servers  = var.domain_name_servers
  ntp_servers          = var.ntp_servers

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.apps_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}

resource "aws_subnet" "apps_subnet" {
  vpc_id            = aws_vpc.apps_vpc.id
  cidr_block        = element(var.apps_subnets, count.index)
  availability_zone = element(var.public_availability_zones, count.index)
  count             = length(var.public_subnets_workloads)

  tags = {
    Name = "${var.org}-${var.project}-apps${count.index}"
  }
}

