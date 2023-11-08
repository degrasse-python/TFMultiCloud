provider "aws" {
  region = "us-east-1" # Modify to your desired region
  access_key = var.AWS_ACCESS_KEY_ID 
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

# Define a VPC and subnets
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example_subnet_1" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "example_subnet_2" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}


# Create an internet gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}


# Define a security group for your instances
resource "aws_security_group" "example_sg" {
  name_prefix = "example-sg-"

  # Define your security group rules here
  # Example rule for SSH access:
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }
  }

resource "aws_instance" "api_example" {
  ami      = "ami-0840becec4971bb87" # CHANGE-ME ami-06a869d0fb5f8ad84 Specify your desired AMI
  instance_type = "t2.micro"             # Choose an appropriate instance type
  associate_public_ip_address = true
  security_groups = [aws_security_group.web_sg.id]
  subnet_id = aws_subnet.example_subnet_1.id
  key_name      = "your-key-name"        # Replace with your key name
  
  /*
  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]

    connection {
      type = "ssh"
      user = "${var.ssh_user}"
      private_key = "${file(${var.private_key_path})}"

    }
  }

  */
  user_data = <<-EOF
              #!/bin/bash
              # User data script for installing a FastAPI web API on Amazon Linux 2

              # Update the system
              sudo yum update -y

              # Install Python 3 and pip
              sudo yum install python3 python3-pip -y

              # Install FastAPI and Uvicorn
              pip3 install fastapi uvicorn

              # Create a directory for your FastAPI app
              mkdir /app
              cd /app

              # Create a simple FastAPI app in a Python script (e.g., main.py)
              cat <<EOL > main.py
              from fastapi import FastAPI

              app = FastAPI()

              @app.get("/")
              def read_root():
                  return {"message": "Hello, FastAPI!"}
              EOL

              # Start the FastAPI app using Uvicorn
              uvicorn main:app --host 0.0.0.0 --port 80 --reload

              # Enable the Uvicorn service to start at boot
              cat <<EOF > /etc/systemd/system/uvicorn.service
              [Unit]
              Description=Uvicorn FastAPI

              [Service]
              ExecStart=/usr/local/bin/uvicorn main:app --host 0.0.0.0 --port 80 --reload
              Restart=always
              StartLimitInterval=0

              [Install]
              WantedBy=multi-user.target
              EOL

              # Enable and start the Uvicorn service
              sudo systemctl enable uvicorn
              sudo systemctl start uvicorn
              EOF


  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --region us-east-1 --instance-ids ${self.id}"
  }

  /*
  provisioner "local-exec2" {
    command = "ansible-playbook -u root -i ${aws_launch_configuration.web_lc.ip_address} 
                --private_key './path2key/key' 
                -e pub-key=${var.ssh_key} 
                ansible-configuration.yaml"
              
  }
  */
}

resource "aws_launch_configuration" "web_lc" {
  name_prefix   = "web-lc-"
  image_id      = "ami-0840becec4971bb87 " # Specify your desired AMI
  instance_type = "t2.micro"             # Choose an appropriate instance type
  security_groups = [aws_security_group.web_sg.id]
  # key_name      = "your-key-name"        # Replace with your key name
  /*

    Why not have ansible do this for you?

  */
  user_data = <<-EOF
              #!/bin/bash
              # User data script for installing a FastAPI web API on Amazon Linux 2

              # Update the system
              sudo yum update -y

              # Install Python 3 and pip
              sudo yum install python3 python3-pip -y

              # Install FastAPI and Uvicorn
              pip3 install fastapi uvicorn

              # Create a directory for your FastAPI app
              mkdir /app
              cd /app

              # Create a simple FastAPI app in a Python script (e.g., main.py)
              cat <<EOL > main.py
              from fastapi import FastAPI

              app = FastAPI()

              @app.get("/")
              def read_root():
                  return {"message": "Hello, FastAPI!"}
              EOL

              # Start the FastAPI app using Uvicorn
              uvicorn main:app --host 0.0.0.0 --port 80 --reload

              # Enable the Uvicorn service to start at boot
              cat <<EOF > /etc/systemd/system/uvicorn.service
              [Unit]
              Description=Uvicorn FastAPI

              [Service]
              ExecStart=/usr/local/bin/uvicorn main:app --host 0.0.0.0 --port 80 --reload
              Restart=always
              StartLimitInterval=0

              [Install]
              WantedBy=multi-user.target
              EOL

              # Enable and start the Uvicorn service
              sudo systemctl enable uvicorn
              sudo systemctl start uvicorn
              EOF

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --region us-east-1 --instance-ids ${self.id}"
  }

  /*
  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]

    connection {
      type = "ssh"
      user = "${var.ssh_user}"
      private_key = "${file(${var.private_key_path})}"

    }
  }
  provisioner "local-exec2" {
    command = "ansible-playbook -u root -i ${aws_launch_configuration.web_lc.ip_address} 
                --private_key './path2key/key' 
                -e pub-key=${var.ssh_key} 
                ansible-configuration.yaml"
              
  }
  */
}

resource "aws_autoscaling_group" "web_asg" {
  name_prefix                 = "web-asg-"
  launch_configuration        = aws_launch_configuration.web_lc.name
  availability_zones         = ["us-east-1a", "us-east-1b"] # Modify to your desired availability zones
  min_size                   = 2   # Minimum number of instances
  max_size                   = 5   # Maximum number of instances
  desired_capacity           = 2   # Initial desired capacity
  health_check_grace_period  = 300 # Adjust as needed
  health_check_type          = "EC2"
  force_delete               = true
  target_group_arns = [aws_lb_target_group.web_target_group.arn]
  
  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web instances"

  // Define your security group rules here
  // Example:
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Additional rules can be added as needed.
}

# Define a load balancer or other networking components as needed for your use case.
resource "aws_lb" "web_nlb" {
  name               = "web-nlb"
  internal           = false  # Set to "true" if it's an internal NLB
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = aws_subnet.example_subnet_1.id # Replace with your subnet IDs
  }

  enable_deletion_protection = false  # Modify as needed
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80  # Port your instances are listening on
  protocol = "TCP"
  vpc_id   = aws_vpc.example_vpc.id  # Replace with your VPC ID
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_nlb.arn
  port              = 80  # Port to listen on
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}
