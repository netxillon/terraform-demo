
# Public Route Table
resource "aws_default_route_table" "default_route_table_public_vpc" {
  default_route_table_id = aws_vpc.public_vpc.default_route_table_id

  tags = {
    Name = "${var.org}-${var.project}-public"
  }
}

resource "aws_route_table_association" "public_subnets_workload" {
  count           = "${length(var.public_subnets_workload)}"
  subnet_id       = "${element(aws_subnet.public_subnets_workload.*.id, count.index)}"
  route_table_id  = aws_default_route_table.default_route_table_public_vpc.id
}

resource "aws_route" "route_public_traffic" {
  route_table_id            = aws_default_route_table.default_route_table_public_vpc.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id	              = aws_internet_gateway.gw.id
  depends_on                = [aws_default_route_table.default_route_table_public_vpc]
}

resource "aws_route" "route_workload_vpc" {
  for_each = {for idx, route in var.private_subnets_redshift: idx => route}
  route_table_id            = aws_default_route_table.default_route_table_public_vpc.id
  destination_cidr_block    = each.value
  transit_gateway_id        = aws_ec2_transit_gateway.tgw.id
  depends_on                = [aws_default_route_table.default_route_table_public_vpc]
}

# Private Route Table
resource "aws_default_route_table" "default_route_table_private_vpc" {
  default_route_table_id = aws_vpc.private_vpc.default_route_table_id

  tags = {
    Name = "${var.org}-${var.project}-private"
  }
}

resource "aws_route_table_association" "private_subnets_workload" {
  count           = "${length(var.private_subnets_workload)}"
  subnet_id       = "${element(aws_subnet.private_subnets_workload.*.id, count.index)}"
  route_table_id  = aws_default_route_table.default_route_table_private_vpc.id
}

resource "aws_route_table_association" "private_subnets_redshift" {
  count           = "${length(var.private_subnets_redshift)}"
  subnet_id       = "${element(aws_subnet.private_subnets_redshift.*.id, count.index)}"
  route_table_id  = aws_default_route_table.default_route_table_private_vpc.id
}

resource "aws_route" "route_private_traffic" {
  route_table_id            = aws_default_route_table.default_route_table_private_vpc.id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id        = aws_ec2_transit_gateway.tgw.id
  depends_on                = [aws_default_route_table.default_route_table_private_vpc]
}
