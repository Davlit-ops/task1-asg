# Internet Gateway for the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw-${var.environment}"
    Environment = var.environment
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-nat-eip-${var.environment}"
    Environment = var.environment
  }
}

# NAT Gateway placed in Public Subnet 2
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name        = "${var.project_name}-nat-gw-${var.environment}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}
