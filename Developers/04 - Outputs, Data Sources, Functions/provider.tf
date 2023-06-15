terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.65.0"
    }
  }

backend "s3" {
    bucket = "timing-remote-state-bucket"
    key = "session-4" # In this key, it'll store the state file.
    region = "ap-south-1"
    dynamodb_table = "timing-lock"

}
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}