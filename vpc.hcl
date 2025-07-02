terraform {
  source = "./modules/vpc"
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOT
provider "aws" {
  region = "us-east-1"
}
EOT
}

inputs = {
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidr = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  vpc_name = "staj-vpc"
}
