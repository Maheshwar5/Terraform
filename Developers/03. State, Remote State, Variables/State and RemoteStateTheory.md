Agenda:
=======
State, remote state, variables

Project Name: timing


Terraform is a declarative way of approach
Whatever you declare, you'll get that infra

Whenver terraform creates infra, it generates file called terraform.tfstate

To track what terraform has created, the status
'''
terraform.tfstate
'''

TF files => whatever we want = Desired infra
terraform.tfstate = Actual infra = current state of infra

Desired Infra = Actual Infra

terraform will always maintain the state whatever you declare

If you remove the terraform.tfstate file, it will again recreate. 
This is the probelem. It relies on terraform.tfstate file to maintain the change.


Problems:
--------
Keeping terraform.tfstate in local is a problem.

If you lose the data then terraform can't track what happened earlier. It'll try to recreate

In case of version control, keeping the terraform state in Github also causes problem while infra is creating through CI CD.

The Best practice is to keep the state file in Remote S3 location for better collaboration between team members.





# Question:
-----------
Explain the state in terraform?
Ans: Terraform uses state file to check the desired configuration VS actual configuration.

If you keep the state file in local, there is a chance of duplication of resources and errors.

Always you should keep the state file in remote location like S3 and you should lock it with Dynamo DB. 

In that case, if one person is performing the terraform changes then it'll be locked and another person cannot be able to do any changes. The state is always secured.




# variables:
variables.tf --> Where you declare variables, you can keep default values as well.

# terraform.tfvars --> 
terraform.tfvars --> Here you can override default values. 
You should've your own values to the variables, if you don't want own values, then default 
values from variables.tf will be applied.


