output "ip_address" { 
  value = aws_instance.practice-instance.public_ip
}

output "ami_id" {
    value = data.aws_ami.ami_info.image_id
}

