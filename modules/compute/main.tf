# --- 1. SECURITY GROUPS (SG) ---

# SG for the Application Load Balancer (ALB)
# Allows HTTP traffic (80) from anywhere (Internet)
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from the internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "coworking-alb-sg" }
}

# SG for the EC2 Instances (Node.js)
# Allows traffic ONLY from the ALB and manages egress to the DB
resource "aws_security_group" "app_sg" {
  name_prefix = "app-sg-"
  vpc_id      = var.vpc_id

  # Ingress: Access HTTP/Node.js (port 8080) ONLY from the ALB's Security Group
  ingress {
    from_port   = 8080 
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description = "Allow traffic only from ALB"
  }

  # Ingress: SSH Access (Optional, for maintenance)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # NOTE: Restrict this to your specific IP in a real scenario
    description = "Allow SSH from anywhere (Temporary)"
  }

  # Egress: CRITICAL RULE: Allows application instances to talk to the DB
  egress {
    from_port       = 5432                   # PostgreSQL port
    to_port         = 5432
    protocol        = "tcp"
    # Reference the Security Group ID of the database
    security_groups = [var.database_security_group_id] 
    description     = "Allow outbound traffic to RDS PostgreSQL"
  }

  # Egress: General Internet Access (for updates, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "coworking-app-sg" }
}

# --- 2. APPLICATION LOAD BALANCER (ALB) ---

resource "aws_lb" "main" {
  name               = "coworking-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids
  tags = { Name = "coworking-alb" }
}

# Target Group: Destination group where the ALB sends traffic
resource "aws_lb_target_group" "app" {
  name        = "coworking-app-tg"
  port        = 8080 # Port where the Node.js microservice listens
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path = "/" # Define the Health Check path for your Node.js API
    port = 8080
  }
}

# Listener: Receives HTTP traffic on port 80 and forwards it to the Target Group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# --- 3. AUTO SCALING GROUP (ASG) ---

# Launch Template: Defines the configuration of the instance
resource "aws_launch_template" "main" {
  name_prefix   = "coworking-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true 
    security_groups             = [aws_security_group.app_sg.id]
  }

  # IAM Profile Attachment (New Feature)
  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }

  user_data = base64encode(file("${path.module}/../user_data/app_startup.sh")) # Startup script
  
  tags = {
    Name = "coworking-instance"
  }
}

# Auto Scaling Group: Manages the number and health of instances
resource "aws_autoscaling_group" "main" {
  name                 = "coworking-asg"
  vpc_zone_identifier  = var.public_subnet_ids
  desired_capacity     = var.min_size
  min_size             = var.min_size
  max_size             = var.max_size
  target_group_arns    = [aws_lb_target_group.app.arn]
  health_check_type    = "ELB" # Uses the ALB's Health Check

  launch_template {
    id      = aws_launch_template.main.id
    version = "$$Latest"
  }
}