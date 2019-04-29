variable "vpc_endpoint_service_name" {
  description = "Name of VPC Endpoint Service to which attach VPC Endpoint"
}

variable "vpc_id" {
  description = "The identifier of the VPC for VPC Endpoint"
}

variable "subnets" {
  type        = "list"
  description = "A list of subnet IDs for VPC Endpoint"
  default     = []
}

variable "alternative_bucket_name_for_targets" {
  description = "Custom S3 bucket name for list of targets for which to create R53 entries (leave empty to use default)"
  default     = ""
}


variable "common_tag" {
  type        = "map"
  description = "Single tag to be assigned to each resource (that supports tagging) created by this module"

  default = {
    "key"   = "environment"
    "value" = "dev"
  }
}
