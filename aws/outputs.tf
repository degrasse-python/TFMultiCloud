output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.example_asg.name
}

output "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  value       = aws_autoscaling_group.example_asg.desired_capacity
}

output "web_nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.web_nlb.dns_name
}
