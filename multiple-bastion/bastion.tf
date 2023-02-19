module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.0.0"

  for_each = var.ec2_bastion

  name                   = each.value.name
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  key_name               = each.value.key_pair
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name
  user_data              = file("${path.module}/bastion.sh")
}

module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "bastion-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

}

resource "aws_iam_role" "bastion_role" {
  name = "bastion_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "bastion_role"
  }
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion_profile"
  role = aws_iam_role.bastion_role.name
}

resource "aws_iam_role_policy_attachment" "bastion_role_AdministratorAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.bastion_role.name
}
