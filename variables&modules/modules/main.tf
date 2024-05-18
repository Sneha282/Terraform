provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value = "ami-07caf09b362be10b8" # replace this
  instance_type_value = "t2.micro"
}
