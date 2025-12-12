# modules/compute/variables.tf

# --- Network Inputs ---
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where resources will be deployed."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB and EC2 instances."
}

# --- Database Dependency Input ---
variable "database_security_group_id" {
  type        = string
  description = "The Security Group ID of the RDS instance to allow outbound traffic to."
}

# --- Instance Configuration Inputs ---
variable "ami_id" {
  type        = string
  description = "The AMI ID for the EC2 instances."
}

variable "instance_type" {
  type        = string
  description = "The instance type (e.g., t3.micro) for the EC2 instances."
}

variable "key_name" {
  type        = string
  description = "The key pair name for SSH access to the instances."
}

# --- Scaling (ASG) Inputs ---
variable "min_size" {
  type        = number
  description = "Minimum number of instances in the Auto Scaling Group."
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in the Auto Scaling Group."
  default     = 4
}

# --- IAM Input (New) ---
variable "iam_instance_profile_arn" {
  type        = string
  description = "The ARN of the IAM instance profile to attach to the EC2 instances."
}

