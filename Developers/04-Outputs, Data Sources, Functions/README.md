### outputs
We're creating infra and we to see what are the outputs we can get through infra.

```
output "name_you_prefer" {

    value = ""
}
```

Refernce: Attributes Reference
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance



# It fetch the IP Address as we've mentioned in outputs.tf
output.tf:
output "ip_address" { 
  value = aws_instance.web.public_ip
}
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

# output: after "terraform apply"
Outputs:

ami_id = "ami-022d03f649d12a49d"
current_region = {
  "description" = "Asia Pacific (Mumbai)"
  "endpoint" = "ec2.ap-south-1.amazonaws.com"
  "id" = "ap-south-1"
  "name" = "ap-south-1"
}
ip_address = "3.108.53.0" ---> public IP of EC2 instance
=====================================================================



### Data Sources
Data source is useful to get the information from cloud or any external provider.
To get automaically, you need to've Data Source. 

Data Source: To fetch the data from the CLoud providers automatically!

This information will be used as inputs for your infrastructure.















# variables.tf
variables.tf --> where you declare variables, you can keep default values

# terraform.tfvars
terraform.tfvars --> Here, you can override default values. 
You should've your own values to the variables, if you don't have your own values, then default values in variables.tf will be applied!

It is user specific. We should gitignore it! (We shouldn't push it to Central Repository)



