output "r53_private_zones" {
  description = "List of private Route53 zones created"
  value       = "${module.vpc-endpoint-test.r53_private_zones}"
}

output "r53_records" {
  description = "List of Route53 records created"
  value       = "${module.vpc-endpoint-test.r53_records}"
}
