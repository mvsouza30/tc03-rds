variable "region" {
  description = "The AWS region where resources will be created."
  type        = string
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
}

variable "my_ip_address" {
  description = "My public IP address"
  type        = string
}

variable "terraform_path" {
  description = "My public IP address"
  type        = string
}