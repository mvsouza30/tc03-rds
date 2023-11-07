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

# Crie um proxy para conexão ao banco de dados
resource "aws_db_proxy" "proxy" {
  name                   = "proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = "arn:aws:iam::${var.id}:role/${var.role}"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  vpc_subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  auth {
    client_password_auth_type = "MYSQL_NATIVE_PASSWORD"
    description = "Autenticação padrão com a senha do MySQL"
    iam_auth    = "DISABLED"
  }

  tags = {
    Name = "proxy"
    Key  = "connect"
  }
}

# Crie um banco de dados e tabelas na instância RDS MySQL
resource "null_resource" "create_database_and_tables" {
  depends_on = [aws_db_instance.default]
  provisioner "local-exec" {
    command = <<EOT
    mysql -h ${aws_db_instance.default.address} -u ${aws_db_instance.default.username} -p${aws_db_instance.default.password} <<MYSQL_SCRIPT
    CREATE DATABASE qtopdb;
    USE qtopdb;
    CREATE TABLE cardapio (
      id INT AUTO_INCREMENT PRIMARY KEY,
      item VARCHAR(255),
      preco DECIMAL (10, 2) NOT NULL,
      descricao VARCHAR(255) NOT NULL,
      arquivo VARCHAR(25) NOT NULL
    );
    MYSQL_SCRIPT
    EOT
  }

  triggers = {
    db_instance_id = aws_db_instance.default.id
  }
}