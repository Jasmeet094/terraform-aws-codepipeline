# Environment
environment = "prod"
# VPC Variables
vpc_name = "myvpc"
vpc-cidr = "10.0.0.0/16"
az-vpc = ["us-west-2a", "us-west-2b", "us-west-2c"]
public-subnet = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
private-subnet = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
database-subnet= ["10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24"]


# EC2 Instance Variables
instance-type = "t3.micro"
key = "terraform-key"

# DNS Name
dns_name = "prod.jasmeetdevops.com"
