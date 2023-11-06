output "rds_endpoint" {
  description = "Endpoint for the RDS database"
  value       = aws_db_instance.qtop_db.endpoint
}

output "rds_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.qtop_db.id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.qtop_s3.bucket
}
