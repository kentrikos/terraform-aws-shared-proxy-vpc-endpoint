# A Terraform module to deploy VPC Endpoint and Route53 records for corresponding VPC Endpoint Service

This module will create consumer-side of VPC Endpoint Service - the VPC Endpoint and R53 private hosted zones with records
matching targets of NLB created for the Endpoint Service (see repository: <https://github.com/kentrikos/terraform-aws-shared-proxy-vpc-endpoint-service>).
Sharing information about targets between producer and consumer side of connection is implemented with S3 bucket.

## Preparations

* The recommended way to use the module is to first deploy VPC Endpoint Service using <https://github.com/kentrikos/terraform-aws-shared-proxy-vpc-endpoint-service> repository.

## Usage

```hcl
module "vpc-endpoint-test" {
  source = "github.com/kentrikos/terraform-aws-shared-proxy-vpc-endpoint.git"

  vpc_endpoint_service_name = "${var.vpc_endpoint_service_name}"
  vpc_id                    = "${var.vpc_id}"
  subnets                   = "${var.subnets}"
}
```

## Notes/limitations:

* Targets on producer-side that share exactly the same DNS name and only differ by ports may cause conflicts when creating R53 records.
  To workaround (or customize R53 entries) you can provide custom list of targets via `alternative_bucket_name_for_targets` variable.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alternative\_bucket\_name\_for\_targets | Custom S3 bucket name for list of targets for which to create R53 entries (leave empty to use default) | string | `""` | no |
| common\_tag | Single tag to be assigned to each resource (that supports tagging) created by this module | map | `<map>` | no |
| subnets | A list of subnet IDs for VPC Endpoint | list | `<list>` | no |
| vpc\_endpoint\_service\_name | Name of VPC Endpoint Service to which attach VPC Endpoint | string | n/a | yes |
| vpc\_id | The identifier of the VPC for VPC Endpoint | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| r53\_private\_zones | List of names of private Route53 zones created |
| r53\_records | List of names of Route53 records created |
