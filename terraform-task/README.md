# terraform_task

TASK:
=====
1. create VPC for EC2 instance
    a. with public subnets in 2 AZs
    b. internet gateway
    c. route table has route to IGW

2. launch AmazonLinux 2 instance with httpd service and hello world website html file
    a. launch server into one of the public subnets
         i. save key file locally
    b. connect to instance
         i. copy key file
         ii. ssh -i keyfile.pem ubuntu@<public ip>
    c. install httpd
         i. sudo yum install httpd
    d. image the instance -> prepare ami from existing instance

3. add to auto scaling group with multi-AZ redundancy
    a. create launch template with image from step (2)
          i. specify image and image type but NOT VPC/subnets
    b. create auto scaling group using launch template
          ii. specify VPC and subnets while creating ASG
    c. create target group and attach to auto scaling group
    d. create application load balancer sending traffic to target group

4. show website in browser

- Perform above tasks manually and after that implement using terraform
- take ca-central-1 region for launching resources
Manul Steps:
let's go through the detailed steps for setting up the VPC, launching an Amazon-Linux-2 instance with HTTPd and a "Hello World" website, and configuring an Auto Scaling Group (ASG) with a load balancer in the ca-central-1 region.

Step 1: Create VPC for EC2 Instance
Login to AWS Console: Go to the AWS Management Console.

Navigate to VPC Dashboard: Click on Services > VPC.

Create VPC:

Click Create VPC.
VPC Settings:
Name tag: MyVPC
IPv4 CIDR block: 10.0.0.0/16
Tenancy: Default
Click Create VPC.
VPC -> Your VPCs -> MyVPC -> select -> Edit VPC settings -> DHCP option set (Enable DNS hostnames + Enable DNS resolution).
Create Subnets:

Click Subnets > Create subnet.
Subnet Settings for Subnet1:
Name tag: PublicSubnet1
VPC: MyVPC
Availability Zone: ca-central-1a
IPv4 CIDR block: 10.0.1.0/24
Click Create subnet.
Subnet Settings for Subnet2:
Name tag: PublicSubnet2
VPC: MyVPC
Availability Zone: ca-central-1b
IPv4 CIDR block: 10.0.2.0/24
Click Create subnet.
Select subnet -> VPC -> Subnets -> subnet-0eaf285c24c954cca -> Edit subnet settings -> Enable auto-assign public IPv4 address.
enable above option in two public subnets, otherwise instances launched in those subnets wont get public ips by default.
Create Internet Gateway (IGW):

Click Internet Gateways > Create internet gateway.
Name tag: MyIGW.
Click Create internet gateway.
Select the created IGW and click Actions > Attach to VPC.
Select MyVPC and click Attach internet gateway.
Create Route Table:

Click Route Tables > Create route table.
Name tag: PublicRouteTable.
VPC: MyVPC.
Click Create route table.
Select the created route table and click Actions > Edit routes.
Click Add route:
Destination: 0.0.0.0/0
Target: Internet Gateway and select MyIGW
Click Save routes.
Click Actions > Edit subnet associations.
Select PublicSubnet1 and PublicSubnet2.
Click Save associations.
Step 2: Launch Amazon Linux 2 Instance with HTTPd
Launch Instance:

Go to the EC2 Dashboard.
Click Launch Instances.
Name: MyEC2
Choose an Amazon Machine Image (AMI): Select Amazon Linux 2 AMI (HVM).
Choose an Instance Type: Select t2.micro (eligible for free tier).
Configure Instance:
Number of instances: 1
Network: Select MyVPC
Subnet: Select PublicSubnet1
Auto-assign Public IP: Enable
Add Storage: Use default settings.
Add Tags: Add a tag (optional).
Configure Security Group:
Create a new security group: LaunchWizard 1
Add Rule: HTTP | TCP | 80 | 0.0.0.0/0
Add Rule: SSH | TCP | 22 | Your-IP-Address/32
Select Key Pair: Choose an existing key pair or create a new one. Download and save the key file locally.
Review and Launch: Review settings and click Launch.
Connect to Instance:

Connect Instance using the pem file or ec2 instance connect
Install Apache and Create a Hello World Website:

Update Package List:
sudo yum update -y
Install Apache:
sudo yum install -y httpd
Start Apache:
sudo systemctl start httpd
sudo systemctl enable httpd
Create a Sample HTML Page:
sudo echo "<html><body><h1>Hello World</h1></body></html>" | sudo tee /var/www/html/index.html
Access the page using public ip http://35.183.107.36/:
Image the Instance:

Go to the EC2 dashboard.
Select your instance.
Click Actions > Image and templates > Create image.
Fill in the Image name and Description.
Click Create image.
Wait till AMI is ready.
MyAMI(check in AMIs section)
Step 3: Add to Auto Scaling Group with Multi-AZ Redundancy
Create Launch Template:

Go to the EC2 Dashboard.
Click on Launch Templates in the sidebar.
Click Create launch template.
Template name: Enter a name: MyLT
Template version description: Optional.
AMI ID: Select the AMI created(or check in My AMIs section owned by me)
Instance type: Select t2.micro.
Key pair: Select your key pair.
Network settings: Leave VPC and subnets unspecified(if u select here, then u wont have scope to launch instances in multiple AZ's)
SG settings: select existing used for MyEC2 SG.
Storage (volumes): Use default settings.
Advanced details -> DNS Hostname -> Enable resource-based IPv4 (A record) DNS requests
Click Create launch template.
Create Auto Scaling Group:

Go to the EC2 Dashboard.
Click on Auto Scaling groups in the sidebar.
Click Create Auto Scaling group.
Auto Scaling group name: Enter a name: MyASG
Launch template: Select the launch template created: MyLT
VPC and Subnets: Select MyVPC and both PublicSubnet1 and PublicSubnet2.
No load balancer: Don't create Load Balancer Here, Create separately, skip this section.
Configure group size and scaling policies: Set desired: 1, minimum: 1, and maximum capacity: 1.
Click Next.
Include Default settings and create ASG.
One new EC2 Instance will be Launched because you have selected desired count: 1
you can access the ip, you will get website displayed -> http://3.99.191.239
Create Target Group:

Navigate to EC2 Dashboard.
Click Target Groups > Create target group.
Choose target type > instances.
Name: MyTG
Basic configuration:
Target type: Instance
Protocol: HTTP
Port: 80 (target group listens on this port because our app listens on this port)
VPC: MyVPC
Click Next.
Health checks:
Protocol: HTTP
Path: /index.html
Click Next.
Register targets: select instance and click on include as pending below -> register pending targets, instance will be in unused state until it receives traffic from LB
Click Create target group.
Create Application Load Balancer:

Navigate to EC2 Dashboard.
Click Load Balancers > Create Load Balancer.
Select Load Balancer Type: Choose Application Load Balancer.
Configure Load Balancer:
Name: MyLB
Scheme: Internet-facing.
Listeners: Add HTTP listener.
Availability Zones: Select MyVPC and both PublicSubnet1 and PublicSubnet2.
Configure Security Settings: Skip (as it's for HTTP).
Configure Security Groups: Select an existing security group or create a new one for alb, allow only 80 and 443 from outside
Configure Routing:
Target group: Select the created target group.
Click Create Load Balancer.
Step 4: Test the Setup
Access the Load Balancer DNS:
Go to target group and check whether Targets are healthy
Go to Load Balancers in the EC2 dashboard.
Select your load balancer and copy the DNS name.
Open a web browser and paste the copied DNS name, your site will be accessed
You should see the "Hello World" message, confirming that your website is working.

image

By following these steps, you have set up a VPC with public subnets in two Availability Zones, launched an Amazon Linux 2 instance with HTTPd, created an AMI, and configured an Auto Scaling Group with a load balancer to manage your web server automatically.

Terraform Steps:
install terraform
sudo apt update -y
sudo apt install awscli -y
sudo apt install wget unzip
pwd
/home/ubuntu
mkdir terraform && cd terraform

cat <<EOF >>/home/ubuntu/terraform/terraform-install.sh
#!/bin/sh
touch terraform-install.sh
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
sudo wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
sudo unzip terraform_${TER_VER}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
EOF

chmod 755 terraform-install.sh
bash terraform-install.sh
which terraform
terraform --version
create first VPC and SG seperetely
cd VPC

- check variables.tf file for values

terraform init
terraform plan
terraform apply

Outputs:

lb_sg_id = "sg-0a72d9abf258c4956"
public_sg_id = "sg-07cb0e6a56c07980e"
public_subnet_1_id = "subnet-0bf55b0a46cdb6ba7"
public_subnet_2_id = "subnet-081fe455765966829"
vpc_id = "vpc-0eced1a0c6e463c0d"

- public_sg_id -> 22,80,443
- lb_sg_id     -> 80
- you can also allow only load balancer security group to instances if you want
For AMI creation, to ASG use packer
- it is recommended to use Packer for AMI's otherwise we would have used Terraform 
cd PACKER

installing packer:
------------------
- my application will run on 80 port, people will access it on port 80
sudo apt update -y
sudo apt install jq -y
LATEST_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r .current_version)
wget https://releases.hashicorp.com/packer/${LATEST_VERSION}/packer_${LATEST_VERSION}_linux_amd64.zip
unzip packer_${LATEST_VERSION}_linux_amd64.zip
sudo mv packer /usr/local/bin/
packer --version

cd PACKER
ls
packer.pkr.hcl  userdata.sh

packer init packer.pkr.hcl
packer validate packer.pkr.hcl
packer build packer.pkr.hcl

amazon-ebs.example: AMI: ami-0a761e7046802d0a2

- we have ami-id
- we have vpc-id
- we have public subnets(1,2)
- security groups(instance, loadbalancer)

lb_sg_id = "sg-0a72d9abf258c4956"
public_sg_id = "sg-07cb0e6a56c07980e"
public_subnet_1_id = "subnet-0bf55b0a46cdb6ba7"
public_subnet_2_id = "subnet-081fe455765966829"
vpc_id = "vpc-0eced1a0c6e463c0d"

create launch template, ASG, Target Group, Loadbalancer
cd LOADBALANCER

- update terraform.tfvars vars with above step values

lb_sg_id = "sg-0a72d9abf258c4956" public_sg_id = "sg-07cb0e6a56c07980e" public_subnet_1_id = "subnet-0bf55b0a46cdb6ba7" public_subnet_2_id = "subnet-081fe455765966829" vpc_id = "vpc-0eced1a0c6e463c0d"


terraform init
terraform plan
terraform apply

- access the application using loadbalancer dns name
example-alb-158988557.us-west-2.elb.amazonaws.com
Enhancements
- we need to use terraform remote s3 backend for statefile management
- we need to modularize the code for reusability and readability
- we need to implement terraform workspaces inorder to deploy in different environments
