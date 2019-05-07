variable "vpc_endpoint_service_name" {
  default = "com.amazonaws.vpce.AWS_REGION.vpce-svc-00000000000000000"
}

variable "vpc_id" {
  default = "vpc-00000000000000000"
}

variable "subnets" {
  default = ["subnet-00000000000000000", "subnet-00000000000000000", "subnet-00000000000000000"]
}

variable "region" {
  default = ""
}
