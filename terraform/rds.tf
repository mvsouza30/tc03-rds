# Crie uma instância do Amazon RDS MySQL
resource "aws_db_instance" "default" {
  allocated_storage     = 10
  db_name               = "qtopdb"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  username              = var.db_username
  password              = var.db_password
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
  publicly_accessible   = false
  multi_az              = false
  vpc_security_group_ids = "aws_security_group.rds-sg.id"
}

resource "aws_vpc" "rds-vpc" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_subnet" "subnet_az1" {
  vpc_id            = aws_vpc.rds-vpc.id
  cidr_block        = "172.31.1.0/24"
  availability_zone = var.availability_zone_01
  map_public_ip_on_launch = false

  tags = {
    Name = "rds-sn-gp-az1"
  }
}

resource "aws_subnet" "subnet_az2" {
  vpc_id            = aws_vpc.rds-vpc.id
  cidr_block        = "172.31.2.0/24"  # Substitua com a sua CIDR única
  availability_zone = var.availability_zone_02
  map_public_ip_on_launch = false
  tags = {
    Name = "rds-sn-gp-az2"
  }
}

resource "aws_db_subnet_group" "rds-sn-gp" {
  name       = "rds-sn-gp"
  subnet_ids = [aws_subnet.subnet_az1.id, aws_subnet.subnet_az2.id]
}

resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Descrição do grupo de segurança para RDS"
  vpc_id      = aws_vpc.rds-vpc.id

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 3306
    to_port   = 3306
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "rds_hostname" {
  value = aws_db_instance.default.endpoint
}

# Crie um banco de dados e tabelas na instância RDS MySQL
#resource "null_resource" "create_database_and_tables" {
  #depends_on = [aws_db_instance.default]
  #provisioner "local-exec" {
    #command = "mysql -h ${aws_db_instance.default.address} -u ${aws_db_instance.default.username} -p${aws_db_instance.default.password} < script.sql"
     #}
    #}
