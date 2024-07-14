# Terraform setup in codespaces

1. Open codespaces and start.
  
2. Install terraform and AWS CLI.
   
In search bar type >add dev container configuration files ,modify your active configuration, then type terraform and AWS CLI(verified one with tick mark). Then rebuild the container. You can see Terraform and AWS CLI is installed.


![image](https://github.com/user-attachments/assets/63b09843-9325-4304-9412-3456b72df66c)

# Steps and Explanation For Task

###  The first part is Building the terraform project, app.py deployment to EC2

### The second part is - integrate with CI/CD

1. There is a development team …they have app.py file., Every time they make changes to app.py file.
Devops team have to create terraform project.

2. To test their changes they want to create VPC, Subnet, route table…destination to route is IGW. We have Associate RT with subnet, so that it will become public subnet.

3. You need to create EC2 instance, and deploy app.py and expose to external world. Once they hit EC2 Public ip , application should be accessible.
============================================================================================

EC2 User data- for small scripts

When you want to execute complex scripts on EC2, you will use provisioners.

==========================================================================================
App.py consists of app code.

Main.tf consists of complete terraform code.
==========================================

######## To create AWS key pair from terraform file, we have to generate key in our machine using below command

ssh-keygen -t rsa

`resource "aws_key_pair" "example" {
  key_name   = "terraform-task1"  # Replace with your desired key name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}`


To run the terraform project execute below commands

1. Terraform init

2. Terraform validate

3. Terraform Plan

4. Terraform apply

5. Terraform destroy



After creating infra and deployed EC2 using file, remote-exec provisioners, we can login to server and check.

ssh -i  ~/.ssh/id_rsa ubuntu@pubip of created instance

To access the app in browser

pubip of created instance:80






   
   




