# Get all AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Public Subnet 1
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, 0) # 10.0.0.0/27
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1-${var.environment}"
  }
}

# Public Subnet 2
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, 1) # 10.0.0.32/27
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2-${var.environment}"
  }
}

# App Private Subnet 1
resource "aws_subnet" "app_private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 2) # 10.0.0.64/27
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-app-private-subnet-1-${var.environment}"
  }
}

# App Private Subnet 2
resource "aws_subnet" "app_private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 3) # 10.0.0.96/27
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-app-private-subnet-2-${var.environment}"
  }
}

# DB Private Subnet 1
resource "aws_subnet" "db_private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 4) # 10.0.0.128/27
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-db-private-subnet-1-${var.environment}"
  }
}

# DB Private Subnet 2
resource "aws_subnet" "db_private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 5) # 10.0.0.160/27
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-db-private-subnet-2-${var.environment}"
  }
}
