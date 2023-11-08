output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.name
}

output "asg_target_group_arns" {
  description = "Target Group ARNs of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.target_group_arns
}

output "asg_launch_configuration" {
  description = "Config of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.launch_configuration
}

output "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.desired_capacity
}

output "web_nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.web_nlb.dns_name
}
