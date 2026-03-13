variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "task1-asg"
}

variable "environment" {
  description = "The environment name"
  type        = string
  default     = "dev"
}
