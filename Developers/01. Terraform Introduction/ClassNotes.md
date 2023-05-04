# Session-01

# initializing terraform
$ terraform init

# terraform plan

# Creating the sample instance
---------------------------------
resource  "aws_instance" "web" {
    ami = "ami-022d03f649d12a49d"  # ami differ for every region
    instance_type = "t2.micro"   
    tags = { Name = "demo-instance" }  
}
---------------------------------

$ terrafrom plan

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami                                  = "ami-022d03f649d12a49d"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + vpc_security_group_ids               = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.


 # Commit the plan

 $ terraform apply

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.web: Creating...
aws_instance.web: Still creating... [10s elapsed]
aws_instance.web: Still creating... [20s elapsed]
aws_instance.web: Still creating... [30s elapsed]


# Creating instance with name using tags:

resource  "aws_instance" "web" {
    ami = "ami-022d03f649d12a49d"
    instance_type = "t2.micro"   
    tags = { Name = "demo-instance" }  
}




# To destroy the infra
$ terraform destroy

 # aws_instance.web will be destroyed

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.web: Destroying... [id=i-0ae522c3008f23718]
aws_instance.my_practice: Destroying... [id=i-04c39a77a23b071f4]
aws_instance.web: Still destroying... [id=i-0ae522c3008f23718, 10s elapsed]
aws_instance.my_practice: Still destroying... [id=i-04c39a77a23b071f4, 10s elapsed]
aws_instance.web: Still destroying... [id=i-0ae522c3008f23718, 20s elapsed]
aws_instance.my_practice: Still destroying... [id=i-04c39a77a23b071f4, 20s elapsed]
aws_instance.web: Destruction complete after 29s
aws_instance.my_practice: Destruction complete after 29s

Destroy complete! Resources: 2 destroyed.





