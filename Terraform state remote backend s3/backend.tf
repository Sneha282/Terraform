terraform {
  backend "s3" {
    bucket         = "sneha-tf-s3-backend" # change this
    key            = "sneha/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
