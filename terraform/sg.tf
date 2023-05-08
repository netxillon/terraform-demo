resource "aws_default_security_group" "default_private_vpc" {
  vpc_id      = aws_vpc.private_vpc.id

  ingress {
      protocol  = -1
      self      = true
      from_port = 0
      to_port   = 0
      description = "Allow traffic within private vpc"
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-default-private-vpc"
  }
}

# Public VPC SGs
resource "aws_default_security_group" "default_public_vpc" {
  vpc_id      = aws_vpc.public_vpc.id

  ingress {
      protocol  = -1
      self      = true
      from_port = 0
      to_port   = 0
      description = "Allow traffic within public vpc"
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-default-public-vpc"
  }
}

resource "aws_security_group" "dbt_public_vpc" {
  name        = "${var.org}-${var.project}-${var.environment}-dbt"
  description = "Allow traffic from Public VPC to Redshift"
  vpc_id      = aws_vpc.private_vpc.id

  ingress {
    protocol      = "tcp"
    from_port     = 5439
    to_port       = 5439
    cidr_blocks   = [var.public_vpc]
    description = "Allow traffic from dbt through Ingress Public VPC"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-dbt"
  }
}
