# private ec2 security group

module "private_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"


  name        = "${local.name}-private-sg"
  description = "Security group for private insatnces"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}