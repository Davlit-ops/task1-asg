variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "db_private_subnet_ids" {
  description = "List of private subnets for RDS"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security Group ID for RDS passed from networking module"
  type        = string
}
