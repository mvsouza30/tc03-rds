resource "aws_vpc_security_group_ingress_rule" "vpc_ingress" {
  security_group_id = aws_security_group.rds_sg.id

  cidr_ipv4   = "10.0.0.0/16"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

#resource "aws_vpc" "my_vpc" {
  #cidr_block = "10.0.0.0/16"
#}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc_security_group_ingress_rule.vpc_ingress.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc_security_group_ingress_rule.vpc_ingress.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-"
  description = "Allow TLS inbound traffic"  
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}