# Creating VPC:
resource "aws_vpc" "main" { # This name belongs to only terraform purpose
 cidr_block       = "10.0.0.0/16"
 instance_tenancy = "default"
 tags = { Name = "automated VPC" } # This name belongs to aws
}  

# Creating Public Subnet: 
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id # It'll fetch VPC ID created by above above code.
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet-automated-vpc"
  }
}

# Creating Private Subnet: 
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet-automated-vpc"
  }
}


# Creating Internetgateway:
resource "aws_internet_gateway" "automated-igw" {
  vpc_id = aws_vpc.main.id # Internetgateway depends on VPC

  tags = {
    Name = "automated-igw"
  }
}


# Creating Routes:

# 1. Creating Public Route: 
# While creating this resource, terraform will go and fetch the internetgateway created above & then it'll attach to this route!   
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.automated-igw.id
  }

  tags = {
    Name = "public-rt"
  }
}


# 1.1 Creating Elastic IP
resource "aws_eip" "auto-eip" {
  
}


# 1.2 Creating NAT gateway
resource "aws_nat_gateway" "automated-NAT" {
  allocation_id = aws_eip.auto-eip.id
  subnet_id     = aws_subnet.main.id # main is the name of public subnet

  tags = {
    Name = "automated-NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.automated-igw]
}



# 1.3 Creating Private Route:
resource "aws_route_table" "private-rt" { # For private route we don't attach IGW. We attach NAT!
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.automated-NAT.id
  }

  tags = {
    Name = "private-rt"
  }
}


# Route Table & Subnet Association:
# Attaching Public Route Table to the Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public-rt.id
}



# Private Association:
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private-rt.id
}