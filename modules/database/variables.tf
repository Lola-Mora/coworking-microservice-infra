# modules/database/variables.tf

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the DB will be deployed."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the DB Subnet Group."
}

variable "db_instance_class" {
  type        = string
  description = "The instance type of the RDS instance (e.g., db.t3.micro)."
  default     = "db.t3.micro"
}

variable "db_name" {
  type        = string
  description = "The initial database name."
  default     = "coworkingdb"
}

variable "db_username" {
  type        = string
  description = "Master username for the database."
  # In a real project, this would be retrieved from a secure secret store (e.g., AWS Secrets Manager)
}

variable "db_password" {
  type        = string
  description = "Master password for the database."
  sensitive   = true # Important: Marks the value as sensitive in plans/outputs
}