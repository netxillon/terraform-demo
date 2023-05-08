resource "aws_vpc" "private_vpc" {
  cidr_block           = var.private_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.org}-${var.project}-vpc-${var.environment}"
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
  vpc_id          = aws_vpc.private_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}

resource "aws_subnet" "private_subnets_tgw" {
  vpc_id            = aws_vpc.private_vpc.id
  cidr_block        = element(var.private_subnets_tgw, count.index)
  availability_zone = element(var.private_availability_zones, count.index)
  count             = length(var.private_subnets_tgw)

  tags = {
    Name = "${var.org}-${var.project}-public-tgw-dedicated${count.index}"
  }
}

resource "aws_subnet" "private_subnets_redshift" {
  vpc_id            = aws_vpc.private_vpc.id
  cidr_block        = element(var.private_subnets_redshift, count.index)
  availability_zone = element(var.private_availability_zones, count.index)
  count             = length(var.private_subnets_redshift)

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-redshift${count.index}"
  }
}

resource "aws_subnet" "private_subnets_workload" {
  vpc_id            = aws_vpc.private_vpc.id
  cidr_block        = element(var.private_subnets_workload, count.index)
  availability_zone = element(var.private_availability_zones, count.index)
  count             = length(var.private_subnets_workload)

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-workload${count.index}"
  }
}



