output "r53_private_zones" {
  description = "List of private Route53 zones created"
  value       = "${module.vpc-endpoint.r53_private_zones}"
}

output "r53_records" {
  description = "List of Route53 records created"
  value       = "${module.vpc-endpoint.r53_records}"
}

output "vpce_id" {
  description = "The ID of the VPC endpoint"
  value       = "${module.vpc-endpoint.vpce_id}"
}
