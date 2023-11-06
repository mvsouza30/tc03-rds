provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "qtop_db" {
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "qtop_db"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
}
