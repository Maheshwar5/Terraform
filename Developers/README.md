<p>

01. Basic commands:

Unlock the terraform state:
* Usage: syntax: terraform force-unlock [options] LOCK_ID

```
terraform force-unlock LOCK_ID
```

To skip manual approve
* Usage: syntax: terraform apply -auto-approve


Terraform variable values from command line:
Reference: 
Syntax: terraform plan -var "<VARIABLE_NAME>=<VARIABLE_VALUE>"
Example Usage: terraform plan -var "username=Learning-Ocean"


<br>
<br>
<br>

Session 02:
<p>

3Tier Architecture:

* Project Infrastructure outline:
* Public subnet, Private subnet, Route Table, IGW are dependent on VPC. 

* Elastic IP is not dependent on any resource. 
* NAT Gateway is dependent on Elastic IP & IGW. We publish NAT Gateway into the Public subnet.

<br>

Creating a VPC

* This session is about creating VPC through Terraform. One should have basic knowledge of VPC.
* Below is the dependency diagram for better understanding.

* First we create VPC.
* Create Subnets. Public and Private into the above VPC.
* Create Internet Gateway.
* Attach Internet Gateway to VPC.
* Create Route Tables. Usually public and private. Route table will have automatic route of VPC.
* Associate route tables with subnets.
* Create EIP. Here elastic IP is independent resource.
* Create NAT gateway. NAT gateway has explicit dependency on Internet Gateway.

![alt text](vpc.jpg)

</p>

<br>
<br>
<br>


Session 03: 
State, Remote State, Variables


State:

* Terraform is a declarative way of approach. Declarative means whatever you write(declare) you will get it provided you will follow proper syntax.

* Whenever terraform creates infra, it will create file called **terraform.tfstate**, it needs someway to track what it created, that is state file

TF files = whatever we want = Desired infra
terraform.tfstate = Actual Infra = current state of Infra

Terraform responsibility is to maintain

Desired Infra = Actual Infra

<br>

Remote State
<p>

* keeping terraform.tfstate in local is a problem, 
* If you lose the data then terraform can't track what happened earlier. It will try to recreate again.
* In case of version control, keeping the terraform state in GitHub also causes problem while infra is creating through CICD. If multiple triggers to the pipeline then duplicate infra would be created.
* It is best practice to keep the state file in remote locations like S3 for better collaboration between team members.


* A central place, where terraform can understand actual infra: Advantages
* Multiple persons should not change infra at a time, only one change is allowed. --> Lock it using dynamoDB.

* Duplication and errors in terraform will be removed

<br>

Creating S3 bucket:
* Go to buckets --> Bucket Nmae: timing-remote-state-bucket --> Bucket Versioning: Enable --> CreateBucket
* Go to DynamoDB --> Go to Tables --> Create Table --> Table Name: timing-lock --> Partition Key: LockID --> Create Table



* Now where ever we run terraform apply it connects to S3 and avoid the situations of duplicate infra. We need to lock with dynamodb so that multiple persons can't apply at the same time.


<br>
<br>


Variables
<p>

* Variables are useful to define values that can be reused across many resources. A central place where a change of value can be reflected everywhere it is used.

Datatypes of variables in terraform are
* string
* number
* list
* map
* boolean
</p>

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

* We use **variables.tf** file to declare variables, we can place default values here. **terraform.tfvars** is the file we declare the default values. We can override variable values from command line using -var "key=value".

<br>

Best Way:
* Create variables.tf and terraform.tfvars
* Place default values in variables.tf
* Override default values using terraform.tfvars. We usually don't commit terraform.tfvars into Git so that users can define their own values.
* Any variable can be overriden at run time using -var "key=value"




My Notes:

Variables:

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

<br>

Reference:
Declaring an Input Variable
https://developer.hashicorp.com/terraform/language/values/variables

<br>

Pass Variable from Command Line: https://learning-ocean.com/tutorials/terraform/terraform-pass-variable-from-cli


```
Syntax: terraform plan -var "<VARIABLE_NAME>=<VARIABLE_VALUE>"
```

Method1:
<p>

```
$ terraform apply -var "cidr=10.0.0.0/16"
```
<>/p
<br>

Method2:
<p>
* Using terraform.tfvars
* In terraform.tfvars file, you mention...


This file is to pass the default values 
cidr = "10.0.0.0/16"

```
$ terraform apply
```
</p>

<br>

* What happens when runtime is, 
* When running vpc.tf, terraform understands there is a variable, then, it goes to the variable in variables.tf and it will check for the value here, if it is not available here, then it'll go to the terraform.tfvars

* In case if it doesn't find the value in terraform.tfvars too, then it'll ask you from the command line.

* But you can always overwrite from the command line.


<br>

6. Merge
<p>

Merging the values.
Refernce:   

* In runtime, it'll fetch all the variables related to the tags, and the Name in the terraform.tfvars will be merged with the given Name from vpc.tf



* Now, our configuration is little clean

* We're maintaing the values in variables
* Providing the default values through terraform.tfvars
* Keeping tags in a central location, same tags will be applied for every resource
* Tags are very important while filtering the resource
* We're merging each resource with the centralized tags


If you apply,

It'll change the resource names...



7. List
<p>

Variables: variables.tf
* In Terraform, variables.tf is a file used to define input variables, while terraform.tfvars is a file used to assign values to those input variables. Here's a more detailed explanation of both:

variables.tf: 
* This file is used to define input variables for your Terraform project. Input variables allow you to parameterize your configuration, making it more reusable and flexible. In variables.tf, you define the variables you need, along with their data types and any constraints you want to put on them. Here's an example variables.tf file:

<p>

```
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
```
</p>

* In this example, we define three input variables: instance_count, instance_type, and ami. instance_count is a number with a default value of 1, instance_type is a string with a default value of "t2.micro", and ami is a string with a default value of "ami-0c55b159cbfafe1f0".

<br>

terraform.tfvars: terraform.tfvars
* This file is used to assign values to the input variables defined in variables.tf. This file is not required, but it's useful because it allows you to keep your configuration separate from your variable assignments, making it easier to manage. 

Here's an example terraform.

```
tfvars file:
instance_count = 3
instance_type  = "t2.small"
ami            = "ami-0c55b159cbfafe1f0"
```


* In this example, we assign values to the input variables we defined in variables.tf. We set instance_count to 3, instance_type to "t2.small", and ami to "ami-0c55b159cbfafe1f0".

* When we run terraform apply, Terraform will read the values from terraform.tfvars and use them to create our infrastructure. If we don't provide a value for a variable in terraform.tfvars, Terraform will use the default value specified in variables.tf. If we don't specify a default value in variables.tf, Terraform will prompt us for a value when we run terraform apply.

* terraform.tfvars is user specific. We should gitignore it! (We shouldn't push it to Central Repository)

<br>
<br>
<br>

Session 04: 
Outputs, Data Sources, Functions

key-pair:

aws key pair 

Resource: aws_key_pair
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair


<br>

Public & Private key:
* public key
* private key

public key: Atatched to instance
private key: Use it to login. Don't push it to any Git or any repo!

<br>

To create public & private key-pair:
```
ssh-keygen -f terraform
```
Save private key in secure location in laptop. It should not be pushed to Git!


Synatx aws_keypair:
```
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa "
}
```

Example:
```
resource  "aws_instance" "practice-instance" {
    ami = data.aws_ami.ami_info.image_id
    instance_type = "t2.micro"   
    tags = { Name = "practice-instance" }
    key_name = aws_key_pair.deployment.key_name 
}

resource "aws_key_pair" "deployment" {
  key_name   = "deployment-key"
  # This `file()` function will read the terraform.pub and fetch the content 
  public_key = file("${path.module}/terraform.pub")
}  
```
This `file()` is a function that can read the file and fetch the content at runtime.


Reference for file() function:
https://developer.hashicorp.com/terraform/language/functions/file


<br>



Functions: Outputs, Data Sources, Functions 

Outputs
<p>

* We're creating infra and we to see what are the outputs we can get through infra.

```
output "name_you_prefer" {

    value = ""
}
```

Refernce: Attributes Reference
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance



* It fetch the IP Address as we've mentioned in outputs.tf
output.tf:
```
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
```

<br>

Data Sources
Syntax: 

```
ouput "name_you_prefer" {
  value = ""
}
```

* Data source is useful to get the information from cloud or any external provider.
To get automaically, you need to've Data Source. 

Data Source:
* To fetch the data from the CLoud providers automatically!

* This information will be used as inputs for your infrastructure.
instance

<br>


Functions
<p>

* In Terraform, functions are used to manipulate data, perform operations on data, or transform data in some way. Functions can be used within Terraform configuration files to dynamically generate values for resources, variables, and other configuration elements.

There are several types of functions in Terraform:


0. lookup function:
<p>

* The lookup() function in Terraform is used to retrieve the value of a specific key from a map or object. It's especially useful when working with variable maps that may not have all keys defined or may have nested values.

The syntax for the lookup() function is as follows:
```
lookup(map, key, default)
```

where map is the `map` or object to search, `key` is the key to retrieve the value of, and `default` is the value to return if the key is not found.

Here's an example that demonstrates the use of the `lookup()` function:

```
locals {
  servers = {
    "web1" = {
      "ip" = "10.0.0.1"
      "port" = 80
    }
    "web2" = {
      "ip" = "10.0.0.2"
      "port" = 80
    }
  }
}

resource "aws_instance" "example" {
  count = length(local.servers)

  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.example.id
  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "example-instance-${count.index}"
    IP = lookup(local.servers[count.index], "ip", "")
    Port = lookup(local.servers[count.index], "port", "")
  }
}

data "aws_subnet" "example" {
  filter {
    name = "tag:Name"
    values = ["example-subnet"]
  }
}

data "aws_security_group" "example" {
  name = "example-security-group"
}

```

* In the above example, the lookup() function is used to retrieve the ip and port values from the local.servers map for each EC2 instance being created. The default argument is used to provide an empty string if the key is not found in the map.

* I hope this helps clarify the usage of the lookup() function in Terraform!
</p>



1. Numeric Functions: These functions perform mathematical operations on numeric values. Some examples of numeric functions include min(), max(), floor(), ceil(), and abs().
Example:
```
resource "aws_instance" "example" {
  instance_type = "t2.micro"
  count = max(1, var.instances)
  ami = data.aws_ami.ubuntu.id
}
```
In the above example, the max() function is used to ensure that the count of instances is at least 1.


2. String Functions: These functions perform operations on strings, such as concatenation, splitting, and trimming. Some examples of string functions include concat(), split(), trim(), and lower().

Example:
```
resource "aws_route53_record" "example" {
  name = "${var.hostname}.${var.domain}"
  type = "A"
  ttl = 300
  records = [aws_eip.example.public_ip]
}
```
In the above example, the concat() function is used to concatenate the hostname and domain name.


3. Collection Functions: These functions perform operations on collections of data, such as lists and maps. Some examples of collection functions include length(), element(), keys(), and values().
Example:
```
locals {
  instance_names = [
    "web-1",
    "web-2",
    "web-3",
  ]
}

resource "aws_instance" "example" {
  count = length(local.instance_names)

  tags = {
    Name = element(local.instance_names, count.index)
  }

  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}
```

In the above example, the length() function is used to determine the number of instances to create, and the element() function is used to assign a unique name to each instance.


4. Date and Time Functions: These functions perform operations on date and time values, such as formatting and converting between different date and time formats. Some examples of date and time functions include formatdate(), parse() and timestamp().
Example:
```
locals {
  current_time = timestamp()
}

output "current_time" {
  value = formatdate("YYYY-MM-DD hh:mm:ss", local.current_time)
}
```

In the above example, the timestamp() function is used to get the current time in Unix time format, and the formatdate() function is used to convert that time to a human-readable format.

These are just a few examples of the many functions available in Terraform. Functions can be used to simplify and automate complex configuration tasks, and they can help make Terraform configurations more flexible and dynamic.


5. Conditional Functions: These functions perform operations based on conditions and boolean values. Some examples of conditional functions include coalesce(), if(), and can().

Example:
```
resource "aws_instance" "example" {
  ami = can(data.aws_ami.ubuntu) ? data.aws_ami.ubuntu.id : var.custom_ami_id
  instance_type = "t2.micro"
}
```
In the above example, the can() function is used to check if the data.aws_ami.ubuntu data source exists, and if it does, the AMI ID is obtained from it. If it doesn't exist, the var.custom_ami_id variable is used.


6. Type Conversion Functions: These functions convert values between different data types. Some examples of type conversion functions include list(), set(), map(), jsonencode(), and yamldecode().

Example:
```
variable "my_list" {
  type = list(string)
  default = ["value1", "value2"]
}

resource "aws_ssm_parameter" "example" {
  name = "/my/parameter"
  type = "StringList"
  value = jsonencode(var.my_list)
}
```
In the above example, the jsonencode() function is used to convert the list of string values to a JSON-encoded string, which is then used as the value for an AWS SSM parameter of type StringList.

Overall, functions are a powerful feature in Terraform that allow for dynamic and flexible configuration. By using functions, you can write more concise and maintainable code that can adapt to changing requirements and conditions.


7. Encoding and Decoding Functions: These functions are used for encoding and decoding data in various formats, such as base64, URL encoding, and percent encoding. Some examples of encoding and decoding functions include base64encode(), urldecode(), and percentencode().

Example:
```
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-${base64encode(var.bucket_suffix)}"
}
```

Sure, here are some more functions in Terraform:

Encoding and Decoding Functions: These functions are used for encoding and decoding data in various formats, such as base64, URL encoding, and percent encoding. Some examples of encoding and decoding functions include base64encode(), urldecode(), and percentencode().
Example:

bash
Copy code
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-${base64encode(var.bucket_suffix)}"
}
In the above example, the base64encode() function is used to encode the bucket_suffix variable as a base64-encoded string, which is then used as part of the S3 bucket name


8. Filesystem Functions: These functions are used for working with files and directories on the local filesystem. Some examples of filesystem functions include file() and pathexpand().

Example:
```
data "template_file" "example" {
  template = file("${pathexpand("~")}/templates/example.tpl")
  vars = {
    my_var = var.my_var
  }
}
```

Sure, here are some more functions in Terraform:

Encoding and Decoding Functions: These functions are used for encoding and decoding data in various formats, such as base64, URL encoding, and percent encoding. Some examples of encoding and decoding functions include base64encode(), urldecode(), and percentencode().
Example:

bash
Copy code
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-${base64encode(var.bucket_suffix)}"
}
In the above example, the base64encode() function is used to encode the bucket_suffix variable as a base64-encoded string, which is then used as part of the S3 bucket name.

Filesystem Functions: These functions are used for working with files and directories on the local filesystem. Some examples of filesystem functions include file() and pathexpand().
Example:

kotlin
Copy code
data "template_file" "example" {
  template = file("${pathexpand("~")}/templates/example.tpl")
  vars = {
    my_var = var.my_var
  }
}
In the above example, the file() function is used to read the contents of a file located in the user's home directory, and the pathexpand() function is used to expand the ~ character to the user's home directory path.


9. Hashing and Encryption Functions: These functions are used for hashing and encrypting data, such as passwords and sensitive information. Some examples of hashing and encryption functions include 
`md5()`,`sha256()`, and `bcrypt()`

Example:
```
resource "aws_kms_key" "example" {
  description = "Example KMS key"
  policy = jsonencode({
    Version = "2012-10-17"
    Id = "key-policy-1"
    Statement = [
      {
        Sid = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "kms:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_db_instance" "example" {
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  allocated_storage = 20
  name = "example-db"
  username = "example-user"
  password = aws_kms_key.example.key_id == "" ? var.db_password : bcrypt(var.db_password, aws_kms_key.example.arn)
}
```
In the above example, the bcrypt() function is used to encrypt the database password with a KMS key if the KMS key exists, otherwise the password is used as-is.


10. AWS Functions: These functions are used for working with AWS resources and services. Some examples of AWS functions include aws_region(), aws_account_id(), and aws_vpc_id().

Example:
```
resource "aws_instance" "example" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.example.id
  vpc_security_group_ids = [aws_security_group.example.id]
}

data "aws_subnet" "example" {
  filter {
    name = "tag:Name"
    values = ["example-subnet"]
  }
}

data "aws_security_group" "example" {
  name = "example-security-group"
}

output "aws_region" {
  value = aws_region()
}
```
In the above example, the `aws_subnet.example.id` and `aws_security_group.example.id` functions are used to retrieve the IDs of a subnet and security group, respectively. The `aws_region()` function is used to output the current AWS region.


11. Join function:
Tthe `join()` function is another common function used in Terraform. It is used to concatenate a list of strings into a single string using a specified delimiter.

The syntax for the join() function is:
```
join(delimiter, list)
```

where delimiter is the string used to separate the elements in the resulting string, and list is the list of strings to concatenate.

Example:
```
variable "tags" {
  type = list(string)
  default = ["env:dev", "app:example"]
}

resource "aws_instance" "example" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.example.id
  vpc_security_group_ids = [aws_security_group.example.id]
  tags = {
    Name = "example-instance"
    Tags = join(",", var.tags)
  }
}

data "aws_subnet" "example" {
  filter {
    name = "tag:Name"
    values = ["example-subnet"]
  }
}

data "aws_security_group" "example" {
  name = "example-security-group"
}
```
In the above example, the join() function is used to concatenate the list of tags with a comma separator, and the resulting string is used as the value for the Tags tag on the EC2 instance. This allows for multiple tags to be set on the instance with a single Terraform variable.


12. cidrsubnet()
`cidrsubnet()`  function: This function is used to generate a subnet IP address range based on a given CIDR block. The syntax is as follows:

```
cidrsubnet(iprange, newbits, netnum)
```
where iprange is the CIDR block to subnet, newbits is the number of additional bits to add to the subnet mask, and netnum is the subnet number to generate. 
Here's an example:

```
locals {
  network_cidr_block = "10.0.0.0/16"
  subnet_bits = 8
  num_subnets = 4
}

resource "aws_subnet" "example" {
  count = local.num_subnets
  cidr_block = cidrsubnet(local.network_cidr_block, local.subnet_bits, count.index)
  vpc_id = aws_vpc.example.id
}

resource "aws_vpc" "example" {
  cidr_block = local.network_cidr_block
}
```
In the above example, the cidrsubnet() function is used to generate four subnets within the 10.0.0.0/16 CIDR block.


13. `format()` function: 
<p>

* This function is used to format a string with values from other variables. The syntax is as follows:

```
format(formatstring, arg1, arg2, ...)
```
* where formatstring is the string to format, and arg1, arg2, etc. are the variables to insert into the string. 
Here's an example:
```
locals {
  message = "Hello, %s!"
  name = "Alice"
}

output "greeting" {
  value = format(local.message, local.name)
}
```
* In the above example, the format() function is used to insert the value of local.name into the local.message string.


14. `file()` function: 
<p>

* This function is used to read the contents of a file on the local file system. The syntax is as follows:

file(path)


* where path is the path to the file to read. 
Here's an example:
```
locals {
  config_file = file("${path.module}/config.yaml")
}

output "config" {
  value = local.config_file
}
```

* In the above example, the file() function is used to read the contents of a YAML file in the same directory as the Terraform configuration file.
</p>


<br>
<br>


variables.tf
* variables.tf --> where you declare variables, you can keep default values

<br>
<br>


terraform.tfvars
* terraform.tfvars --> Here, you can override default values. 
You should've your own values to the variables, if you don't have your own values, then default values in variables.tf will be applied!

* It is user specific. We should gitignore it! (We shouldn't push it to Central Repository)

<br>
<br>
<br>

Session 05: 
Count, Conditions, Loops

<br>
<br>
<br>

Concepts:
* terraform: terraform basics - working on 03 session
* terraform-modules
* timing-infra

<br>
<br>
