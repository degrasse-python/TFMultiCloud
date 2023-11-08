# Configure terraform cloud
terraform {
  cloud {
    organization = "Energy_Stars"

    workspaces {
      name = "TFMultiCloud"
    }
  }
}

module "aws" {
  source = "./modules/aws_instance"
  launch_template_id = aws_launch_configuration.web_lc.name
  max_size = 5
  asg_name = "web-asg-"
  subnets = 2
  vpc_id = aws_vpc.example_vpc.id
  min_size = 2
  desired_capacity = 2
  security_groups = [aws_security_group.web_sg.id]
  ami_id = "ami-06a869d0fb5f8ad84" //  ami-06a869d0fb5f8ad84
  instance_type = "t2.micro"
  AWS_ACCESS_KEY_ID  = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY  = var.AWS_SECRET_ACCESS_KEY 
}

module "google" {
  source = "./modules/gcp_instance"
  zone = var.zone
  region = var.region
  project_id = var.project_id
  gcp_credentials_file = var.gcp_credentials_file
  GOOGLE_CREDENTIALS = var.GOOGLE_CREDENTIALS
}
