# Subnet group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group-${var.environment}"
  subnet_ids = var.db_private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group-${var.environment}"
  }
}

# PostgreSQL Instance
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-db-${var.environment}"
  allocated_storage = 20
  storage_type      = "gp3"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro" # cheap / free tier

  db_name  = "llmdb"
  username = "postgres"
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  # Security
  storage_encrypted          = true
  auto_minor_version_upgrade = true

  skip_final_snapshot = true # skip backup
  multi_az            = false
  publicly_accessible = false

  tags = {
    Name = "${var.project_name}-db-${var.environment}"
  }
}
