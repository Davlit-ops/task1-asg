# Public route table (Routes to Internet Gateway)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt-${var.environment}"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Private route table (Routes to NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${var.environment}"
  }
}

# App Subnets
resource "aws_route_table_association" "app_private_1" {
  subnet_id      = aws_subnet.app_private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "app_private_2" {
  subnet_id      = aws_subnet.app_private_2.id
  route_table_id = aws_route_table.private.id
}

# Route table for Database
resource "aws_route_table" "db_isolated" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-db-isolated-rt-${var.environment}"
  }
}

# DB Subnets
resource "aws_route_table_association" "db_private_1" {
  subnet_id      = aws_subnet.db_private_1.id
  route_table_id = aws_route_table.db_isolated.id
}

resource "aws_route_table_association" "db_private_2" {
  subnet_id      = aws_subnet.db_private_2.id
  route_table_id = aws_route_table.db_isolated.id
}
