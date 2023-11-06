output "rds_endpoint" {
  description = "Endpoint for the RDS database"
  value       = aws_db_instance.qtop_instance.endpoint
}

output "rds_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.qtop_instance.id
}