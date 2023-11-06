provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "data_network"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "qtop_rds"
  }
}

resource "aws_security_group" "qtop_sg" {
  name   = "qtop_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "qtop_rds"
  }
}

resource "aws_db_parameter_group" "qtop-pg" {
  name   = "qtop-pg"
  family = "mysql5.7"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "qtop_instance" {
  identifier             = "qtop_instance"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.qtop_sg.id]
  parameter_group_name   = aws_db_parameter_group.qtop_pg.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}
