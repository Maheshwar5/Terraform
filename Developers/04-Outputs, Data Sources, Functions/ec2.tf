resource  "aws_instance" "practice-instance" {
    ami = data.aws_ami.ami_info.image_id
    instance_type = "t2.micro"   
    tags = { Name = "practice-instance" } 
    key_name = aws_key_pair.deployment.key_name
}

resource "aws_key_pair" "deployment" {
  key_name   = "deployment"
  # This `file()` function will read the terraform.pub and fetch the content 
  public_key = file("${path.module}/deployment.pub")
}  