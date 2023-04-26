
resource "aws_default_route_table" "default_route_table_public_vpc" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  tags = {
    Name = "${var.org}-${var.project}-public"
  }
}

resource "aws_route_table_association" "public_workloads" {
  count           = "${length(var.apps_subnets)}"
  subnet_id       = "${element(aws_subnet.workload_subnets.*.id, count.index)}"
  route_table_id  = aws_default_route_table.default_route_table_public_vpc.id
}

resource "aws_route" "route_public_traffic" {
  route_table_id            = aws_default_route_table.default_route_table_public_vpc.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id	              = aws_internet_gateway.gw.id
  depends_on                = [aws_default_route_table.default_route_table_public_vpc]
}

resource "aws_route" "route_test_vpc" {
  for_each = {for idx, route in var.data_vpcs: idx => route}
  route_table_id            = aws_default_route_table.default_route_table_public_vpc.id
  destination_cidr_block    = each.value.id
  transit_gateway_id        = aws_internet_gateway.gw.id
  depends_on                = [aws_default_route_table.default_route_table_public_vpc]
}
/*
resource "aws_route" "route_dev_vpc" {
  route_table_id            = aws_default_route_table.default_route_table_public_vpc.id
  destination_cidr_block    = var.dev_vpc
  transit_gateway_id        = var.transit_gtway_id
  depends_on                = [aws_default_route_table.default_route_table_public_vpc]
} */