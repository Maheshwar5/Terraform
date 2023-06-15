01.  Basic commands:

# Unlock the terraform state:
  Usage: terraform force-unlock [options] LOCK_ID

# To skip manual approve
  Usage: terraform apply -auto-approve









-------------------------------------------------------------------------------
# session 02: 
* 3Tier Architecture:


-------------------------------------------------------------------------------
# session 03: 
* State, Remote State, Variables


### State

Terraform is a declarative way of approach. Declarative means whatever you write(declare) you will get it provided you will follow proper syntax.

Whenever terraform creates infra, it will create file called **terraform.tfstate**, it needs someway to track what it created, that is state file

TF files = whatever we want = Desired infra <br />
terraform.tfstate = Actual Infra = current state of Infra

Terraform responsibility is to maintain

Desired Infra = Actual Infra

### Remote State

keeping terraform.tfstate in local is a problem, 

* If you lose the data then terraform can't track what happened earlier. It will try to recreate again.

* In case of version control, keeping the terraform state in GitHub also causes problem while infra is creating through CICD. If multiple triggers to the pipeline then duplicate infra would be created.

* It is best practice to keep the state file in remote locations like S3 for better collaboration between team members.


* A central place, where terraform can understand actual infra: Advantages

- Multiple persons should not change infra at a time, only one change is allowed. --> Lock it using DynamoDB.

- Duplication and errors in terraform will be removed

* Creating S3 bucket:
- Go to buckets --> Bucket Nmae: timing-remote-state-bucket --> Bucket Versioning: Enable --> CreateBucket
- Go to DynamoDB --> Go to Tables --> Create Table --> Table Name: timing-lock --> Partition Key: LockID --> Create Table



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




# My Notes:

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




# Variables:
  =========

1. If you are repeating the values in multiple places, then you need to do the change in all places if there is a modification 

2. If we use variable change at single place reflects everywhere

3. Keeping the variables aside will save us from acccidental changes.

4. variables.tf file, we need to keep all the variables

5. There are multiple types of variables,
   - string
   - map
   - number = integer
   - boolean = true/false

 * variables.tf is to declare variables. You can keep default values here. But not recommended.
 * terraform.tfvars is to provide default values to variables
 * You can always overwrite values from command line 



Reference:
Declaring an Input Variable
https://developer.hashicorp.com/terraform/language/values/variables


Pass Variable from Command Line: https://learning-ocean.com/tutorials/terraform/terraform-pass-variable-from-cli


Syntax: terraform plan -var "<VARIABLE_NAME>=<VARIABLE_VALUE>"

Method1:
$ terraform apply -var "cidr=10.0.0.0/16"


Method2:
Using terraform.tfvars

in terraform.tfvars file, you mention...

----------------------------------------
# This file is to pass the default values 
cidr = "10.0.0.0/16"
----------------------------------------

$ terraform apply

What happens when runtime is, 
When running vpc.tf, terraform understands there is a variable,
Then, it goes to the variable in variables.tf and it will check for the value here, if it 
is not available here, then it'll go to the terraform.tfvars

In case if it doesn't find the value in terraform.tfvars too, then it'll ask you from the command line.

But you can always overwrite from the command line.




6. Merge

Merging the values.
Refernce:   

In runtime, it'll fetch all the variables related to the tags, and the 
Name in the terraform.tfvars will be merged with the given Name from vpc.tf

-----------------------------------------------------------

Now, our configuration is little clean

- We're maintaing the values in variables
- Providing the default values through terraform.tfvars
- Keeping tags in a central location, same tags will be applied for every resource
- Tags are very important while filtering the resource
- We're merging each resource with the centralized tags


If you apply,

It'll change the resource names...



7. List




-------------------------------------------------------------------------------
# session 04: 
* Outputs, Data Sources, Functions



-------------------------------------------------------------------------------
# session 05: 
* Count, Conditions, Loops



-------------------------------------------------------------------------------








cconcepts:
- terraform: terraform basics - working on 03 session
- terraform-modules
- timing-infra

Just to avoid repeat typing: git add .; git commit -m "Message"; git push origin master