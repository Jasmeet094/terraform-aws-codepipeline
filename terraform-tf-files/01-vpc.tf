# Creation of virtual private cloud

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"
  name    = "${var.vpc_name}-${var.environment}"
  cidr    = var.vpc-cidr

  azs                = var.az-vpc
  private_subnets    = var.private-subnet
  public_subnets     = var.public-subnet
  database_subnets   = var.database-subnet
  
  
  single_nat_gateway = true
  enable_nat_gateway = true
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true

  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = local.common_tags

  # Additional Tags to Subnets
  public_subnet_tags = {
    Type = "Public Subnets"
  }
  private_subnet_tags = {
    Type = "Private Subnets"
  }
  database_subnet_tags = {
    Type = "Private Database Subnets"
  }
}
