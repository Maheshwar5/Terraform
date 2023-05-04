$ cd VPC
$ terraform init
$ terraform plan

$ terraform plan

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "automated VPC"
        }
      + tags_all                             = {
          + "Name" = "automated VPC"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.


$ terraform apply


Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "automated VPC"
        }
      + tags_all                             = {
          + "Name" = "automated VPC"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.main: Creating...
aws_vpc.main: Creation complete after 1s [id=vpc-07770cda030483f57]


# Now, check in aws console!

# After VPC, we need to create Subnet!
Reference for terraform aws VPC: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet


# terraform, first comes to subnet creating code it will check and understands that there is a dependency. So it will fetch VPC info from vpc creation code and then it creates subnet.


# Creating Subnet:

$ terraform plan
aws_vpc.main: Refreshing state... [id=vpc-07770cda030483f57]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_subnet.main will be created
  + resource "aws_subnet" "main" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = (known after apply)
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "public-subnet-automated-vpc"
        }
      + tags_all                                       = {
          + "Name" = "public-subnet-automated-vpc"
        }
      + vpc_id                                         = "vpc-07770cda030483f57"
    }

Plan: 1 to add, 0 to change, 0 to destroy.


$ terraform apply

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_subnet.main: Creating...
aws_subnet.main: Creation complete after 1s [id=subnet-0b39bba25e7ad59db]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.



# Creating another Subnet: private

$ terraform plan
$ terraform apply

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_subnet.private: Creating...
aws_subnet.private: Creation complete after 1s [id=subnet-0f390b331b583e32d]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.


# Create Internetgateway:
Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway



$ terraform plan
$ terraform apply

Internetgateway is created.



# Now, create Routes
# Creating Routes:
# While creating this resource, terraform will go and fetch the internetgateway created above(Internetgateway code) & then it'll attach to this route!   


$ terraform plan
$ terraform apply


# Creating Private Route:

- Private Route is dependent on NAT gateway
Reference for NAT gateway: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway


* Private Route Table: 
1. Private Route Table depends on NAT  
2. NAT depends on elastic IP


- First create Elastic IP Reference: https://registry.terraform.io/providers/-/aws/4.52.0/docs/resources/eip
- Then, NAT
- Then, Create Private Route

- In Private Route Table
- Don't add Internetgateway, because it is a Private.


1. elastic IP
2. NAT gateway
3. Private Route
4. 


Referncee for Route Table and Subnet Association Terraform:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

# We need Associate Public Route to Public Subnet:


Then,


# Similarly, We need to Associate private 








