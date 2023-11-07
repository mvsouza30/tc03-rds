# Crie uma instância do Amazon RDS MySQL
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "qtopdb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name

}

resource "aws_db_proxy" "dbproxy" {
  name                   = "dbproxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = "arn:aws:iam::${var.id}:role/${var.role}"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  vpc_subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  auth {
    client_password_auth_type = "MYSQL_NATIVE_PASSWORD"
    description = "Utilizando a senha do MySQL para autenticar no proxy"
    iam_auth    = "REQUIRED"
    #secret_arn  = aws_secretsmanager_secret.example.arn
  }

  tags = {
    Name = "example"
    Key  = "value"
  }
}

# Crie um banco de dados e tabelas na instância RDS MySQL
resource "null_resource" "create_database_and_tables" {
  depends_on = [aws_db_instance.default]
  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.default.address} -u ${aws_db_instance.default.username} -p${aws_db_instance.default.password} < script.sql"
     }
    }
