# Variables:
------------

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

