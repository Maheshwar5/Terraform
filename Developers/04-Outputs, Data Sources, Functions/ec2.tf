resource  "aws_instance" "practice-instance" {
    ami = data.aws_ami.ami_info.image_id
    instance_type = "t2.micro"   
    tags = { Name = "practice-instance" } 
}