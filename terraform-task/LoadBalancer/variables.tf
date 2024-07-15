# Variables
variable "profile" {
  default = "sonia" # Replace with your AMI ID
}

variable "region" {
  default = "us-west-2" # Replace with your AMI ID
}

variable "ami_id" {
  default = "ami-0b0ee994bcf7a3744" # Replace with your AMI ID
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" {
  default = "vpc-0cae5dfde4394cad3"
}

variable "subnet_ids" {
  default = ["subnet-02c8f0146c9b66cfe", "subnet-0d593d2a6196b22b9"]
}

variable "lb_sg_id" {
  default = "sg-00a7272e63b79ebf1"
}

variable "public_sg_id" {
  default = "sg-0abf840f50ac205fa"
}
