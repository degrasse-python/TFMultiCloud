output "api_example_user_data" {
  description = "Name of the Auto Scaling Group"
  value       = aws_instance.api_example.user_data
}

output "api_example_ip" {
  description = "Target Group ARNs of the Auto Scaling Group"
  value       = aws_instance.api_example.public_ip
}

output "api_example_ami" {
  description = "Config of the Auto Scaling Group"
  value       = aws_instance.api_example.ami
}


output "web_nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.web_nlb.dns_name
}
