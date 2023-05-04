### Outputs


Syntax is
'''

output "name_you_prefer" {

    value = "" 
}
'''

We're creating infrastructure, we want to see what are the outputs we can get through infra.

Reference for what are the outputs we can expect from terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance



# Getting public_ip
$ terraform apply
aws_instance.web: Creating...
aws_instance.web: Creation complete after 31s [id=i-0ca79bdee146a8788]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:
ip_address = "3.110.128.99"


Check in the console: Same IP Address!



### Data Sources
Data source is useful to get the information from cloud or any external provider.

Syntax for data source aws ami: 
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami


Data Source: aws_region
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region






# Troubleshoot Commands:

# terraform unlock: 
syntax: terraform force-unlock <LockID> 

# Creating lock in dynamo db:

Table name: timing-lock
Partition key: LockID

> Create Table


