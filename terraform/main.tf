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
  name       = "rds-sbnt-grp"
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
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.default.id

# Rota para primeira sub-rede do ECS Fargate
  route {
    cidr_block = "172.31.1.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }

# Rota para segunda sub-rede do ECS Fargate
  route {
    cidr_block = "172.31.2.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }

# Rota para terceira sub-rede do ECS Fargate
  #route {
    #cidr_block = "172.31.3.0/24"
    #gateway_id = aws_internet_gateway.gw.id
  #}

# Rota para minha rede
  route {
    cidr_block = "191.5.227.87/32"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associação do Internet Gateway apontando para subnets do ECS Fargate
resource "aws_route_table_association" "route1" {
  route_table_id = aws_route_table.rt.id
  gateway_id     = aws_internet_gateway.gw.id
}

