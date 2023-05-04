variable "aws_accounts" {
    type = map
    default = {
        "ap-south-1" = "137112412989" # Thesee are official aws Acoount ID
        #"ap-south-2" = "052378183071"
    }
}

# How you get value from map is:
# map_name("key")
# [aws_accounts["ap-south-1"]]