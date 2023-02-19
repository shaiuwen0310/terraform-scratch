variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "ec2_bastion" {
  type = map(object({
    name  = string
    instance_type = string
    ami = string
    key_pair = string
  }))
  default = {
    "key1" = {
      instance_type = "t1.micro"
      name = "bastion1"
      ami = "ami-0f1a5f5ada0e7da53"
      key_pair = "judy-windows-keypair"
    },
    "key2" = {
      instance_type = "t2.micro"
      name = "bastion2"
      ami = "ami-0f1a5f5ada0e7da53"
      key_pair = "judy-windows-keypair"
    }
  }
}