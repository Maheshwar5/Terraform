
### variables: variables.tf
In Terraform, variables.tf is a file used to define input variables, while terraform.tfvars is a file used to assign values to those input variables. Here's a more detailed explanation of both:

variables.tf: This file is used to define input variables for your Terraform project. Input variables allow you to parameterize your configuration, making it more reusable and flexible. In variables.tf, you define the variables you need, along with their data types and any constraints you want to put on them. Here's an example variables.tf file:

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type    = string
  default = "ami-0c55b159cbfafe1f0"
}


In this example, we define three input variables: instance_count, instance_type, and ami. instance_count is a number with a default value of 1, instance_type is a string with a default value of "t2.micro", and ami is a string with a default value of "ami-0c55b159cbfafe1f0".


### terraform.tfvars: terraform.tfvars
This file is used to assign values to the input variables defined in variables.tf. This file is not required, but it's useful because it allows you to keep your configuration separate from your variable assignments, making it easier to manage. Here's an example terraform.

tfvars file:
instance_count = 3
instance_type  = "t2.small"
ami            = "ami-0c55b159cbfafe1f0"



In this example, we assign values to the input variables we defined in variables.tf. We set instance_count to 3, instance_type to "t2.small", and ami to "ami-0c55b159cbfafe1f0".

When we run terraform apply, Terraform will read the values from terraform.tfvars and use them to create our infrastructure. If we don't provide a value for a variable in terraform.tfvars, Terraform will use the default value specified in variables.tf. If we don't specify a default value in variables.tf, Terraform will prompt us for a value when we run terraform apply.

terraform.tfvars is user specific. We should gitignore it! (We shouldn't push it to Central Repository)




