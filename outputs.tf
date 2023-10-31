output "aws_instances_name" {
  value = module.aws.*.instance_name
}

output "google_instance_name" {
  value = module.google.*.instance_name
}

output "aws_instances_ips" {
  value = module.aws.*.instance_external_ips
}

output "google_instance_ips" {
  value = module.google.*.instance_external_ips
}

output "db_instance_name" {
  value = module.google.*.db_instance_name
}