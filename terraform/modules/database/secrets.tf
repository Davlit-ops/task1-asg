# Random password
resource "random_password" "db_password" {
  length           = 16
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Store the password in SSM
resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.project_name}/${var.environment}/db_password"
  description = "Password for RDS PostgreSQL"
  type        = "SecureString"
  value       = random_password.db_password.result
}
