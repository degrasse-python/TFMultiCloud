variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created."
  type        = string
}

variable "machine_type" {
  description = "The machine type for your instances."
  type        = string
  default     = "n1-standard-1"  # You can set a default value
}

variable "zone" {
  description = "The GCP zone where resources will be created."
  type        = string
}

variable "gcp_credentials_file" {
  description = "Path to the GCP credentials file in HCL format."
  type        = string
}

variable "GOOGLE_CREDENTIALS" {
  description = "Path to the GCP credentials file in HCL format."
  type        = string
}