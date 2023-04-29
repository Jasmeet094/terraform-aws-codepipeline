# EC2 id
output "ec2_complete_id" {
  description = "The ID of the instance"
  value       = module.ec2_instance.id
}

# ARN of bastion host
output "ec2_complete_arn" {
  description = "The ARN of the instance"
  value       = module.ec2_instance.arn
}

# public ip of bastion host
output "ec2_bastion_public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.ec2_instance.public_ip
}

# private ip of bastion host
output "ec2_bastion_private_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.ec2_instance.private_ip
}


######## Output For Random Provider - pet ##########

output "random-id" {
  value = random_pet.test.id
}