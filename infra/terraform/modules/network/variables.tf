variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "eu-west-1a"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access — restrict to your IP in production"
  type        = string
  default     = "0.0.0.0/0"
}
