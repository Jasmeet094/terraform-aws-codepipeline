# bastion host to connect or shh inot private instances

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "bastion-host-${local.name}"

  ami                    = data.aws_ami.amzn-ami.id
  instance_type          = var.instance-type
  key_name               = var.key
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  tags = local.common_tags
}

