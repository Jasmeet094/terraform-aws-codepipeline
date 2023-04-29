# values for tags used in local.tf file
locals {
  name = "${var.environment}"
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Environment = var.environment
    Department  = "devops"
    Terraform   = "True"
  }
}