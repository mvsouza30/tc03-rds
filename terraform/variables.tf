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

variable "availability_zone_01" {
  description = "Primeira zona de disponibilidade do RDS"
  type        = string
  default     = "us-east-1d"
}

variable "availability_zone_02" {
  description = "Segunda zona de disponibilidade do RDS"
  type        = string
  default     = "us-east-1e"
}

variable "subnet_group_name"{
  type    = string
  default = "rds-sbnt-grp"
}

variable "role" {
  description = "user role."
  type        = string
  default     = "ecsTaskRole"
}
