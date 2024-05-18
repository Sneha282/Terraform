provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
    ami = "ami-07caf09b362be10b8"
    instance_type = "t2.micro"
   
}
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
