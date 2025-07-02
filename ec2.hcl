terraform {
  source = "./modules/ec2"
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
  ami_id = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id = "subnet-04c79d72ba02a36d9"
  security_group_id = "sg-00bf1f2d6e4fab100"
  key_name = "sstaj-key"
  instance_name = "Flask-Server"
}
