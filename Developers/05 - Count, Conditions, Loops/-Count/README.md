# In terraform we've...

variables
data types
functions

conditions
loops

count

minimum 

# count:
count.index is a special variable you'll get, if you use count parameter.


# list:
Terraform get the length of list:
Reference: https://stackoverflow.com/questions/47080292/terraform-get-the-length-of-list


# conditions:
if(expression {
these commands runs if expression is true
}else{
these commands runs if expression is false    
) 

Condition is useful generally to take a decision!

Example:
if (day != sunday ) {
print working day
}
else {
print holiday    
}


# Terraform:
Similarly in terraform 
expression ? "this will execute if true" : "this will execute if expression is false"

