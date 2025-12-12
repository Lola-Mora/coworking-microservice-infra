# modules/database/outputs.tf

output "db_endpoint" {
  description = "The connection endpoint for the RDS instance."
  value       = aws_db_instance.main.address
}

output "db_security_group_id" {
  description = "The Security Group ID for the DB, needed for the Compute module's SG."
  value       = aws_security_group.db_sg.id
}