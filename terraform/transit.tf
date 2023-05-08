resource "aws_ec2_transit_gateway" "tgw" {
  description = "${var.environment}-data-lake-tgw"

  tags = {
    Name = "${var.project}-${var.environment}-twg"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "private_subnets_tgw" {
  subnet_ids         = [aws_subnet.private_subnets_tgw.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.private_vpc.id

  tags = {
    Name = "${var.environment}-Attachment-${var.private_vpc}"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "public_subnets_tgw" {
  subnet_ids         = [aws_subnet.public_subnets_tgw.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.public_vpc.id

  tags = {
    Name = "${var.environment}-Attachment-${var.public_vpc}"
  }
}