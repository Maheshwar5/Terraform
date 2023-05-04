# Creating VPC:
resource "aws_vpc" "main" { # This name belongs to only terraform purpose
 cidr_block       = var.cidr
 instance_tenancy = "default"
 tags = merge(var.tags, {
  Name = "timings"
 })
}  

# Creating Public Subnet: 
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id # It'll fetch VPC ID created by above above code.
  cidr_block = var.public_subnet_cidr # This is hard coding

  tags = merge(var.tags, {
  Name = "public-subnet"
 })
}

# Creating Private Subnet: 
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

   tags = merge(var.tags, {
  Name = "private-subnet"
 })
}


# Creating Internetgateway:
resource "aws_internet_gateway" "automated-igw" {
  vpc_id = aws_vpc.main.id # Internetgateway depends on VPC

   tags = merge(var.tags, {
  Name = "timing-igw"
 })
}


# Creating Routes:

# 1. Creating Public Route: 
# While creating this resource, terraform will go and fetch the internetgateway created above & then it'll attach to this route!   
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.automated-igw.id
  }

  tags = merge(var.tags, {
  Name = "public-route-table"
 })
}


# 1.1 Creating Elastic IP
resource "aws_eip" "auto-eip" {
  
}


# 1.2 Creating NAT gateway
resource "aws_nat_gateway" "automated-NAT" {
  allocation_id = aws_eip.auto-eip.id
  subnet_id     = aws_subnet.public.id # main is the name of public subnet

    tags = merge(var.tags, {
  Name = "timing-ng"
 })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.automated-igw]
}



# 1.3 Creating Private Route:
resource "aws_route_table" "private-rt" { # For private route we don't attach IGW. We attach NAT!
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_nat_gateway.automated-NAT.id
  }

    tags = merge(var.tags, {
  Name = "private-route-table"
 })
}


# Route Table & Subnet Association:
# Attaching Public Route Table to the Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-rt.id
}



# Private Association:
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private-rt.id
}