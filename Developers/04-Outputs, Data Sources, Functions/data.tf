data "aws_ami" "ami_info" {
  most_recent = true
  # owners = ["137112412989"] # This is the official amazon Account ID
  # Instead of hard coding above account ID, we can do as below
  #owners = [var.aws_accounts[data.aws_region.current.name]]
  owners = [lookup(var.aws_accounts,data.aws_region.current.name)]  

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# I want to know, whcih region I'm in! This example will fetch the info reagrding your current region
data "aws_region" "current" {}

output "current_region" {
  value = data.aws_region.current.name
}

# I want to get VPC info of an existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-0f7fbc6773d49f78c"
}

output "vpc_info" {
  value = data.aws_vpc.existing_vpc
}