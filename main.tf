# VPC Endpoint:
resource "aws_vpc_endpoint" "vpce" {
  vpc_id            = "${var.vpc_id}"
  service_name      = "${var.vpc_endpoint_service_name}"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    "${aws_security_group.vpce.id}",
  ]

  subnet_ids          = "${var.subnets}"
  private_dns_enabled = false
}

resource "aws_security_group" "vpce" {
  description = "Control access to VPC Endpoint"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

# Route53:
locals {
  targets_string                 = "${replace(data.aws_s3_bucket_object.vpc_endpoint_service.body, "\n", "")}"
  targets_list                   = "${split(",", local.targets_string)}"
  zones_list_string_temp         = "${replace(local.targets_string, "/,[^\\.]+\\./", ",")}"
  zones_list_string              = "${replace(local.zones_list_string_temp, "/^[^\\.]+\\./", "")}"
  zones_list                     = "${split(",", local.zones_list_string)}"
  zones_list_unique              = "${distinct(split(",", local.zones_list_string))}"
  targets_bucket_name_by_service = "${replace(var.vpc_endpoint_service_name, "/^com.amazonaws.vpce./", "")}"
  targets_bucket_name            = "${local.targets_bucket_name_by_service != "" ? local.targets_bucket_name_by_service : var.alternative_bucket_name_for_targets}"
}

data "aws_s3_bucket_object" "vpc_endpoint_service" {
  bucket = "${replace(var.vpc_endpoint_service_name, "/^com.amazonaws.vpce./", "")}"
  key    = "targets.csv"
}

resource "aws_route53_zone" "this" {
  count = "${length(local.zones_list_unique)}"

  name = "${local.zones_list_unique[count.index]}"

  vpc {
    vpc_id = "${var.vpc_id}"
  }

  # https://github.com/terraform-providers/terraform-provider-aws/issues/3402
  force_destroy = true
}

data "aws_route53_zone" "this" {
  depends_on   = ["aws_route53_zone.this"]
  count        = "${length(local.targets_list)}"
  name         = "${local.zones_list[count.index]}"
  private_zone = true
}

resource "aws_route53_record" "this" {
  count   = "${length(local.targets_list)}"
  zone_id = "${data.aws_route53_zone.this.*.zone_id[count.index]}"
  name    = "${local.targets_list[count.index]}"
  type    = "A"

  alias {
    name                   = "${lookup(aws_vpc_endpoint.vpce.dns_entry[0], "dns_name")}"
    zone_id                = "${lookup(aws_vpc_endpoint.vpce.dns_entry[0], "hosted_zone_id")}"
    evaluate_target_health = true
  }
}
