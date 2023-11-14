variable "aws_region" {
  description = "Região padrão para criação de recursos na AWS."
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  default = "qtop-db"
}

variable "db_username" {
  description = "User do banco de dados."
  type        = string
  default     = "mvsouza"
}

variable "db_password" {
  description = "Auth do banco de dados."
  type        = string
  default     = "Q!W@E#R$"
}

variable "vpc_id" {
  description = "ID da VPC existente."
  type        = string
  default     = "vpc-0d7c15a0ae62a17d5"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-0b37269b5da4f9da5", "subnet-074f800ea4b46e6f2", "subnet-0c0a7dceac41e2bb6"]
}

variable "sg_ids"{
  type    = list(string)
  default = "sg-06b061000fe76fbc4"
}

variable "subnet_group_name"{
  type    = string
  default = "rds-sn-gp"
}

variable "role" {
  description = "user role."
  type        = string
  default     = "ecsTaskRole"
}
