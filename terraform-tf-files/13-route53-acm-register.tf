# ACM Module - To create and Verify SSL Certificates
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.3.2"

  domain_name = data.aws_route53_zone.mydomain.name
  zone_id     = data.aws_route53_zone.mydomain.zone_id

  subject_alternative_names = [var.dns_name]
  tags = local.common_tags
}

# Output ACM Certificate ARN
output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}