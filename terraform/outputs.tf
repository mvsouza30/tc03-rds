output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds-sbnt-grp.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.rds-sbnt-grp.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance port"
  value       = aws_db_instance.rds-sbnt-grp.username
  sensitive   = true
}