output "r53_private_zones" {
  description = "List of names of private Route53 zones created"
  value       = "${aws_route53_zone.this.*.name}"
}

output "r53_records" {
  description = "List of names of Route53 records created"
  value       = "${aws_route53_record.this.*.name}"
}

output "vpce_id" {
  description = "The ID of the VPC endpoint"
  value       = "${aws_vpc_endpoint.vpce.id}"
}
