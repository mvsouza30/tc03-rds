# Crie uma instância do Amazon RDS MySQL
resource "aws_db_instance" "default" {
  address              = var.address
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