# Crie uma instância do Amazon RDS MySQL
resource "aws_db_instance" "rds-sbnt-grp" {
  allocated_storage        = 10
  db_name                  = "qtopdb"
  engine                   = "mysql"
  engine_version           = "5.7"
  instance_class           = "db.t2.micro"
  username                 = var.db_username
  password                 = var.db_password
  db_subnet_group_name     = aws_db_subnet_group.rds-sbnt-grp.id
  parameter_group_name     = "default.mysql5.7"
  skip_final_snapshot      = true
  publicly_accessible      = false
  multi_az                 = false
  vpc_security_group_ids   = [aws_security_group.rds-sg.id]
}

