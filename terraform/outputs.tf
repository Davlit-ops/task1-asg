output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = module.compute.bastion_public_ip
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.compute.alb_dns_name
}

output "db_endpoint" {
  description = "The connection endpoint for the database"
  value       = module.database.db_instance_endpoint
}
