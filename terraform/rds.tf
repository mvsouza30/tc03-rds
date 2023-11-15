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

resource "aws_vpc" "default" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_subnet" "subnet_az1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "172.31.5.0/24"
  availability_zone = var.availability_zone_01
  map_public_ip_on_launch = false

  tags = {
    subnet_name = "rds-sn-gp-az1"
  }
}

resource "aws_subnet" "subnet_az2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "172.31.6.0/24" 
  availability_zone = var.availability_zone_02
  map_public_ip_on_launch = false
  tags = {
    subnet_name = "rds-sn-gp-az2"
  }
}

resource "aws_db_subnet_group" "rds-sbnt-grp" {
  name       = "rds-sn-gp"
  subnet_ids = [aws_subnet.subnet_az1.id, aws_subnet.subnet_az2.id]
}

resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Descricao do grupo de seguranca para RDS"
  vpc_id      = aws_vpc.default.id

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


