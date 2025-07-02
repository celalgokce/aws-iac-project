variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-083ac04a8442d4b7f"  # Amazon Linux 2 eu-north-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be launched"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for EC2"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair name"
  type        = string
  default     = "sstaj-key"
}

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type        = string
  default     = "Flask-Server"
}