### State

Terraform is a declarative way of approach. Declarative means whatever you write(declare) you will get it provided you will follow proper syntax.

Whenever terraform creates infra, it will create file called **terraform.tfstate**, it needs someway to track what it created, that is state file

TF files = whatever we want = Desired infra <br />
terraform.tfstate = Actual Infra = current state of Infra

Terraform responsibility is to maintain

Desired Infra = Actual Infra

### Remote State

keeping terraform.tfstate in local is a problem, 

* if you lose the data then terraform can't track what happened earlier. It will try to recreate again.
* In case of version control, keeping the terraform state in GitHub also causes problem while infra is creating through CICD. If multiple triggers to the pipeline then duplicate infra would be created.
* It is best practice to keep the state file in remote locations like S3 for better collaboration between team members.

Now where ever we run terraform apply it connects to S3 and avoid the situations of duplicate infra. We need to lock with dynamodb so that multiple persons can't apply at the same time.

#### Variables

Variables are useful to define values that can be reused across many resources. A central place where a change of value can be reflected everywhere it is used.

Datatypes of variables in terraform are
* string
* number
* list
* map
* boolean

```
variable "region" {
  type = string
  default = "us-west-2"
}

variable "port" {
  type = number
  default = 8080
}

variable "subnets" {
  type = list(string)
  default = ["subnet-1234abcd", "subnet-5678efgh"]
}

variable "tags" {
  type = map(string)
  default = {
    Name = "web-server"
    Environment = "dev"
  }
}
```

We use **variables.tf** file to declare variables, we can place default values here. **terraform.tfvars** is the file we declare the default values. We can override variable values from command line using -var "key=value".

#### Best Way:
* Create variables.tf and terraform.tfvars
* Place default values in variables.tf
* Override default values using terraform.tfvars. We usually don't commit terraform.tfvars into Git so that users can define their own values.
* Any variable can be overriden at run time using -var "key=value"





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




