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
  vpc_security_group_ids = aws_default_security_group.id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_vpc" "rds-vpc" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_default_subnet" "default_az1" {
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone_01

  tags = {
    subnet_name = "rds-sn-gp"
  }
}

resource "aws_default_subnet" "default_az2" {
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone_02

  tags = {
    subnet_name = "rds-sn-gp"
  }
}

resource "aws_db_subnet_group" "rds-sn-gp" {
  name       = "rds-sn-gp"
  subnet_ids = [aws_default_subnet.default_az1, aws_default_subnet.default_az2]
}

resource "aws_default_security_group" "rds-sg" {
  vpc_id = aws_vpc.rds-vpc.id

  ingress {
    protocol  = tcp
    self      = true
    from_port = 3306
    to_port   = 3306
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
