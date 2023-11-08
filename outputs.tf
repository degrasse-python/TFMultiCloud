output "aws_instances_name" {
  value = module.aws.asg_name
}

output "google_instance_ips" {
  value = module.google.instance_external_ips
}


output "db_instance_ip" {
  value = module.google.postgresql_instance_ip
}