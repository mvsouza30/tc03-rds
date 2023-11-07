variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key for authentication."
  type        = string
  default     = "AKIA6LLYOT7WRQURGZ5R"
}

variable "aws_secret_key" {
  description = "AWS secret key for authentication."
  type        = string
  default     = "FDubf6+oF/yH8gWpqXh7apxhwGCAXy324LSicuMc"
}

variable "db_username" {
  description = "AWS access key for database authentication."
  type        = string
  default     = "mvsouza"
}

variable "db_password" {
  description = "AWS secret key for database authentication."
  type        = string
  default     = "MarcosTeste"
}