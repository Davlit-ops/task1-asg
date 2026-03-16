# IP for SSH connection
output "bastion_public_ip" {
  description = "Public IP address of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

# For Database
output "app_sg_id" {
  description = "ID of the Application Security Group (for LLM instances)"
  value       = aws_security_group.app.id
}

# DNS name
output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}
