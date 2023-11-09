
output "google_instance_ips" {
  value = module.google.instance_external_ips
}


output "db_instance_ip" {
  value = module.google.postgresql_instance_ip
}