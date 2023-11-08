output "aws_instances_name" {
  value = module.aws.*.instance_name
}

output "google_instance_name" {
  value = module.google.*.instance_name
}


output "db_instance_name" {
  value = module.google.*.db_instance_name
}