resource  "aws_instance" "demo-instance" {
    ami = "ami-022d03f649d12a49d"
    instance_type = "t2.micro"   
    tags = { Name = "demo-instance" }  
}


resource  "aws_instance" "my_practice" {
    ami = "ami-022d03f649d12a49d"
    instance_type = "t2.nano"   
    tags = { Name = "my-instance" }  
}