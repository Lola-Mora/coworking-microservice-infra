# modules/iam/outputs.tf

output "instance_profile_arn" {
  description = "ARN of the IAM Instance Profile for EC2."
  value       = aws_iam_instance_profile.app_profile.arn
}