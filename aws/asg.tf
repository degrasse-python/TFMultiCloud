resource "aws_launch_configuration" "web_lc" {
  name_prefix   = "web-lc-"
  image_id      = "ami-0123456789abcdef0" # Specify your desired AMI
  instance_type = "t2.micro"             # Choose an appropriate instance type
  security_groups = [aws_security_group.web_sg.id]
  key_name      = "your-key-name"        # Replace with your key name

  user_data = <<-EOF
              #!/bin/bash
              # You can add user data scripts here for instance setup
              EOF
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
  // ingress {
  //   from_port   = 80
  //   to_port     = 80
  //   protocol    = "tcp"
  //   cidr_blocks = ["0.0.0.0/0"]
  // }

  // Additional rules can be added as needed.
}

# Define a load balancer or other networking components as needed for your use case.
resource "aws_lb" "web_nlb" {
  name               = "web-nlb"
  internal           = false  # Set to "true" if it's an internal NLB
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet_1.id  # Replace with your subnet IDs
    allocation_id = aws_eip.nlb_eip.id             # Optionally allocate an Elastic IP
  }

  enable_deletion_protection = false  # Modify as needed
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80  # Port your instances are listening on
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id  # Replace with your VPC ID
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
