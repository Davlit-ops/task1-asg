variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID from networking module"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets for Bastion and ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnets for ASG instances"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC to restrict egress traffic"
  type        = string
}

variable "app_port" {
  description = "Port on which the LLM application runs"
  type        = number
  default     = 8080
}

variable "db_endpoint" {
  description = "RDS Database endpoint for OpenWebUI"
  type        = string
}

variable "db_password" {
  description = "Database password for OpenWebUI"
  type        = string
  sensitive   = true
}
