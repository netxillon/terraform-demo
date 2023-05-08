resource "aws_vpc" "public_vpc" {
  cidr_block           = var.public_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.org}-${var.project}-vpc-${var.environment}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.public_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_vpc_dhcp_options" "public_dhcp_options" {
  domain_name          = var.domain_name
  domain_name_servers  = var.domain_name_servers
  ntp_servers          = var.ntp_servers

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}"
  }
}

resource "aws_vpc_dhcp_options_association" "public_dns_resolver" {
  vpc_id          = aws_vpc.public_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.public_dhcp_options.id
}

resource "aws_subnet" "public_subnets_tgw" {
  vpc_id            = aws_vpc.public_vpc.id
  cidr_block        = element(var.public_subnets_tgw, count.index)
  availability_zone = element(var.public_availability_zones, count.index)
  count             = length(var.public_subnets_tgw)

  tags = {
    Name = "${var.org}-${var.project}-public-tgw-dedicated${count.index}"
  }
}



