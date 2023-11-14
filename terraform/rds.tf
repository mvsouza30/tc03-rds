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
  publicly_accessible   = true
  multi_az              = false
  vpc_security_group_ids = var.sg_id

  db_subnet_group_name   = var.subnet_group_name
  subnet_ids             = var.subnet_ids

  depends_on = [aws_internet_gateway.igw]
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
