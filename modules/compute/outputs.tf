output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer (ALB) for the Login Service."
  value       = aws_lb.main.dns_name
}