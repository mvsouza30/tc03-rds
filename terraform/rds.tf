# Define provider for AWS
provider "aws" {
    region     = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

# Recurso de segurança do grupo de banco de dados para permitir o tráfego do ECS Fargate
resource "aws_db_security_group" "mydb_security_group" {
  name        = "mydb_security_group"
  description = "Security group for my RDS instance"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"] # Permitir apenas o tráfego da rede do ECS Fargate
  }
}

# Crie uma instância do Amazon RDS MySQL
resource "aws_db_instance" "qtopinstance" {
  allocated_storage    = 5
  db_name              = "qtopdb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "qtopinstance"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_db_security_group.mydb_security_group.id]
}

########-configurar daqui para baixo#########


# Crie um banco de dados e tabelas na instância RDS MySQL
resource "null_resource" "create_database_and_tables" {
  provisioner "local-exec" {
    command = <<EOT
    mysql -h ${aws_db_instance.qtopinstance.endpoint} -u ${aws_db_instance.qtopinstance.username} -p${aws_db_instance.qtopinstance.password} <<MYSQL_SCRIPT
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
    db_instance_id = aws_db_instance.qtopinstance.id
  }
}

resource "aws_db_subnet_group" "mainsubnetgroup" {
  name       = "mainsubnetgroup"
  subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]

  tags = {
    Name = "my_DB_subnet_group"
  }
}

# O Amazon RDS Proxy é um serviço gerenciado que permite melhorar a escalabilidade, a disponibilidade e a segurança
# das conexões de banco de dados com instâncias de banco de dados RDS (Relational Database Service) e Aurora. 
# O proxy de banco de dados age como um intermediário entre seu aplicativo e o banco de dados, gerenciando 
# conexões de forma eficiente e proporcionando recursos como pooling de conexões, balanceamento de carga
# e failover automático.

resource "aws_db_proxy" "proxy" {
  name                   = "proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = "arn:aws:iam::${var.id}:role/${var.role}"
  vpc_security_group_ids = [aws_security_group.mydb_security_group.id]
  vpc_subnet_ids         = aws_subnet.mainsubnetgroup.vpc_subnet_ids

  auth {
    auth_scheme = "SECRETS"
    description = "example"
    iam_auth    = "DISABLED"
    #secret_arn  = aws_secretsmanager_secret.example.arn
  }

  tags = {
    Name = "rdsdb"
    Key  = "ecsfar"
  }
}

# O endpoint do proxy de banco de dados é o endereço de rede que os aplicativos usam para se conectar ao proxy, que, 
# por sua vez, redireciona as conexões para as instâncias de banco de dados RDS ou Aurora subjacentes. 
# Este recurso é útil para configurar e gerenciar os pontos de extremidade do proxy de banco de dados 
# que seus aplicativos usarão para acessar o banco de dados subjacente.

resource "aws_db_proxy_endpoint" "endpoint" {
  db_proxy_name          = aws_db_proxy.name
  db_proxy_endpoint_name = "conn_rds_ecs"
  vpc_subnet_ids         = aws_subnet.aws_subnet.mainsubnetgroup.vpc_subnet_ids
  target_role            = "READ_ONLY"
}