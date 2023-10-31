terraform {
  required_version = ">=1.6.2"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.25"
    }
    google = {
      source = "hashicorp/google"
      version = "~>5.4.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
  profile = "default"
}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
  project    = "ACME"
  region     = "us-central1"
}
