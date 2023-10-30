provider "aws" {
  region = "us-east-1"
}

provider "google" {
  credentials = file("<YOUR_GCP_CREDENTIALS_JSON_FILE>")
  project    = "<YOUR_GCP_PROJECT_ID>"
  region     = "us-central1"
}
