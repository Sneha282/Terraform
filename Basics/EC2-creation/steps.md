# Overview of steps

Create a directory for your Terraform project and create a Terraform configuration file (usually named main.tf) in that directory. In this file, you define the AWS provider and resources you want to create. Here's a basic example:

```terraform
provider "aws" {
  region     = "us-east-1" 
  access_key = "xxx"
  secret_key = "xxx"
}

resource "aws_instance" "example" {
  ami           = "ami-07caf09b362be10b8"  # Specify an appropriate AMI ID
  instance_type = "t2.micro"
  key_name      = "terrraform"
  security_groups = ["launch-wizard-4"]
  tags = {
    Name = "Sneha-Instance"
  }
}

   

    
# Initialize Terraform**

In your terminal, navigate to the directory containing your Terraform configuration files and run:

##
<tab><tab>
terraform init
This command initializes the Terraform working directory, downloading any necessary provider plugins.

Apply the Configuration
Run the following command to create the AWS resources defined in your Terraform configuration:

terraform apply
Terraform will display a plan of the changes it's going to make. Review the plan and type "yes" when prompted to apply it.

Verify Resources
After Terraform completes the provisioning process, you can verify the resources created in the AWS Management Console or by using AWS CLI commands.

# Destroy Resources
If you want to remove the resources created by Terraform, you can use the following command:

terraform destroy
Be cautious when using terraform destroy as it will delete resources as specified in your Terraform configuration.
