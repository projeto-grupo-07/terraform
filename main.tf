provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "brinks-vpc"
  cidr = "10.0.0.0/25"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.0.0/27", "10.0.0.32/27"]
  private_subnets = ["10.0.0.64/27", "10.0.0.96/27"]

  create_igw         = true
  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}