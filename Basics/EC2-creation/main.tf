provider "aws" {
     region = "us-east-1" 
     access_key = "xxx"
     secret_key = "xxx"
   }
 resource "aws_instance" "example" {
     ami           = "ami-07caf09b362be10b8"  # Specify an appropriate AMI ID
     instance_type = "t2.micro"
     key_name = "terrraform"
     security_groups = "launch-wizard-4"
     tags = {
       Name= "Sneha-Instance"
     }
   }
