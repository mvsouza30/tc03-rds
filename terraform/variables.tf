variable "region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
  default     = "mvsouza"
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  default     = "C0n3ct@"
}

variable "my_ip_address" {
  description = "My public IP address"
  type        = string
  default     = "191.5.227.137"
}

variable "terraform_path" {
  description = "My public IP address"
  type        = string
  default     = "terraform"
}