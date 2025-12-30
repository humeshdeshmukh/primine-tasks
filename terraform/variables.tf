variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application Name"
  default     = "my-simulated-app"
}

variable "environment" {
  description = "Environment (e.g. dev, prod)"
  default     = "prod"
}

variable "container_port" {
  description = "Port exposed by the container"
  default     = 80
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}
