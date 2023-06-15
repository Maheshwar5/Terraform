# Our Requirement is to create multiple instances
resource  "aws_instance" "web" {
    ami = "ami-022d03f649d12a49d"
    instance_type = "t2.micro" 
    # The three instances will be created with Name: web.  
    #tags = { Name = "web" }
    
    # I want to give 3 different names for 3 instances!
    # web-server, app-server, db-server
    tags = { Name = var.instances[count.index] } # index always start from 0. 
    count = length(var.instances)
    #key_name = aws_key_pair.deployment.key_name
}


