
resource "aws_db_proxy" "dbproxy" {
  name                   = "dbproxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = "arn:aws:iam::${var.id}:role/${var.role}"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  vpc_subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  auth {
    auth_scheme = "SECRETS"
    description = "Proxy para autenticação no banco de dados"
    iam_auth    = "REQUIRED"
    secret_arn  = aws_secretsmanager_secret.rdssm.arn
  }

  tags = {
    Name = "example"
    Key  = "value"
  }
}