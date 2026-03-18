output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "app_private_subnet_ids" {
  description = "List of IDs of application private subnets"
  value       = [aws_subnet.app_private_1.id, aws_subnet.app_private_2.id]
}

output "db_private_subnet_ids" {
  description = "List of IDs of database private subnets"
  value       = [aws_subnet.db_private_1.id, aws_subnet.db_private_2.id]
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "app_sg_id" {
  value = aws_security_group.app.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}
