variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"  
}

variable "key_name" {
  description = "SSH key pair name to access the instance"
  default="strapinew"
}
variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  type        = string
}

