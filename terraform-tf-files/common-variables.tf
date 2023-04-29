#common generic variables

variable "region" {
  type = string
  default = "us-west-2"
}


# DNS Name Input Variable
variable "dns_name" {
  description = "DNS Name to support multiple environments"
  type = string   
}

variable "environment" {
  type = string
  
}

variable "vpc_name" {
  type = string
  
}

variable "vpc-cidr" {
 type = string 
}

variable "az-vpc" {
  type = list(string)
}

variable "private-subnet" {
 type = list(string) 
}

variable "public-subnet" {
  type = list(string)
}

variable "database-subnet" {
  type = list(string)
}

variable "instance-type" {
 type = string 
}

variable "key" {
 type = string 
}