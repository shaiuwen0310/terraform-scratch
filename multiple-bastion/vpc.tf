module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name            = "bastion-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets  = ["10.0.10.0/24", "10.0.11.0/24"]

  enable_dns_hostnames = true
  enable_dns_support = true

  enable_nat_gateway     = false

}
