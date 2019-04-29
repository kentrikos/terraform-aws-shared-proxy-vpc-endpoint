output "r53_private_zones" {
  description = "List of names of private Route53 zones created"

  value = "${aws_route53_zone.this.*.name}"
}

output "r53_records" {
  description = "List of names of Route53 records created"

  value = "${aws_route53_record.this.*.name}"
}
