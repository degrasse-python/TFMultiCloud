# Variables for Auto Scaling Group
variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

variable "ami_id" {
  description = "The id of the ami"
  type        = string
}

variable "launch_template_id" {
  description = "The ID of the launch template for the Auto Scaling Group"
  type        = string
}

variable "min_size" {
  description = "The minimum number of instances in the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "The maximum number of instances in the Auto Scaling Group"
  type        = number
}

variable "desired_capacity" {
  description = "The initial desired capacity of the Auto Scaling Group"
  type        = number
}

variable "instance_type" {
  description = "The EC2 instance type to be used by the Auto Scaling Group"
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs where instances in the Auto Scaling Group will be launched"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the Auto Scaling Group and instances will be launched"
  type        = string
}

variable "security_groups" {
  description = "A list of security group IDs to associate with instances in the Auto Scaling Group"
  type        = list(string)
}

variable "aws_access_key" {
  description = "The aws_access_key"
  type        = string
}

variable "aws_secret_key" {
  description = "The id aws_secret_key"
  type        = string
}
