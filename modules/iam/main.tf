# modules/iam/main.tf

# 1. IAM Role Definition
resource "aws_iam_role" "app_role" {
  name               = "coworking-app-role"
  # This JSON assumes the file is located relative to the current module:
  assume_role_policy = file("${path.module}/policies/app_assume_role_policy.json") 
  
  tags = { Name = "CoworkingAppRole" }
}

# 2. Attach a Policy (Example: allowing logging to CloudWatch)
resource "aws_iam_role_policy_attachment" "cloudwatch_access" {
  role       = aws_iam_role.app_role.name
  # This uses an AWS built-in policy for EC2 logging
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy" 
}

# 3. IAM Instance Profile (The resource that is attached to EC2)
resource "aws_iam_instance_profile" "app_profile" {
  name = "coworking-app-profile"
  role = aws_iam_role.app_role.name
}