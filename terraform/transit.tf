resource "aws_ec2_transit_gateway" "tgw" {
  description = "example-tgw"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids         = [aws_subnet.example.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-Attachment-${var.main_vpc}"
  }
}