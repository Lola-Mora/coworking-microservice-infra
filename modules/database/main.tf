# modules/database/main.tf

# --- 1. DB SECURITY GROUP (SG) ---
# Allows traffic only from the Application/Compute instances (Node.js)
resource "aws_security_group" "db_sg" {
  name_prefix = "db-sg-"
  vpc_id      = var.vpc_id

  # Allow PostgreSQL traffic (port 5432) from the Compute Security Group
  # NOTE: We need the ID of the Compute Security Group here. 
  # For now, we allow access from the VPC CIDR for validation.
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    # BEST PRACTICE: Use the SG ID of the EC2 instances, not the whole VPC
    cidr_blocks = ["10.0.0.0/16"] 
    description = "Allow DB traffic from within VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "coworking-db-sg" }
}

# --- 2. DB SUBNET GROUP ---
# Required for RDS deployment in the private subnets
resource "aws_db_subnet_group" "main" {
  name       = "coworking-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = { Name = "coworking-db-group" }
}

# --- 3. RDS POSTGRESQL INSTANCE ---
resource "aws_db_instance" "main" {
  identifier           = "coworking-db-instance"
  engine               = "postgres"
  engine_version       = "15.4" # Use a stable version
  instance_class       = var.db_instance_class
  allocated_storage    = 20
  storage_type         = "gp2"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
  
  # Multi-AZ deployment for high availability (Best practice for production)
  multi_az             = true 
  skip_final_snapshot  = true
  publicly_accessible  = false # CRITICAL: Keep DB private

  tags = { Name = "coworking-database" }
}