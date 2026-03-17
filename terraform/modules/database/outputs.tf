output "db_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.main.address
}

output "db_password" {
  description = "The generated password for the database"
  value       = random_password.db_password.result
  sensitive   = true
}
