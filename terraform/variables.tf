variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key for authentication."
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret key for authentication."
  type        = string
  default     = ""
}

variable "db_username" {
  description = "AWS access key for database authentication."
  type        = string
  default     = "mvsouza"
}

variable "db_password" {
  description = "AWS secret key for database authentication."
  type        = string
  default     = ""
}

variable "id" {
  description = "Account ID."
  type        = string
  default     = "986484482029"
}

variable "role" {
  description = "user role."
  type        = string
  default     = "role_to_get_access"
}
