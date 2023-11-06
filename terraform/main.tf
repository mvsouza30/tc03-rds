resource "aws_db_instance" "default" {
  allocated_storage    = 5
  db_name              = "qtop-db"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = db_username
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}