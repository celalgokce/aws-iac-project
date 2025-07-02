
cat > terragrunt.hcl << 'EOF'
remote_state {
  backend = "local"
  config = {
    path = "terraform.tfstate"  # Basit path
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
EOF
}

locals {
  region     = "us-east-1"
  account_id = "762924054702"
}
EOF