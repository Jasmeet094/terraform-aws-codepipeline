# providers used for terraform

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }


    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
 }

 # Adding Backend as S3 for Remote State Storage
  backend "s3" { } 
}

# configure aws provider
provider "aws" {
  region = var.region
}


# Create Random Pet Resource
resource "random_pet" "test" {
  length = 2
}



