terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_key_pair" "ec2_ssh" {
  key_name = "ec2_ssh_key"
  public_key = file("./ec2_ssh_key.pub")
}

resource "aws_default_vpc" "my_default_vpc" {
  
}

# data "aws_subnets" "default_vpc_subnets"{
#   filter {
#     name = "vpc-id"
#     values = [aws_default_vpc.my_default_vpc.id]
#   }
#   # filter {
#   #   name = "default-for-vpc"
#   #   values = ["true"]
#   # }
#   depends_on = [ aws_default_vpc.my_default_vpc ]
# }
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}


resource "aws_security_group" "my-kub-ec2-sg" {
  vpc_id = aws_default_vpc.my_default_vpc.id
  ingress{
    from_port = 22 
    to_port = 22 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 80 
    to_port = 80 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 443 
    to_port = 443 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress  {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  depends_on = [ aws_default_vpc.my_default_vpc ]
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.5"
  key_name = aws_key_pair.ec2_ssh.key_name 
  vpc_security_group_ids = [aws_security_group.my-kub-ec2-sg.id]
  for_each = local.ec2_kubernetes_nodes
  ami = each.value.ami
  instance_type = each.value.instance_type
  subnet_id = each.key == "master_node"? data.aws_subnets.default_vpc_subnets.ids[1]:data.aws_subnets.default_vpc_subnets.ids[2]
  user_data = each.key == "master_node"? file("./custom_scripts/master_node_config.sh") : file("./custom_scripts/worker_node_config.sh")
  associate_public_ip_address = true
  depends_on = [ aws_default_vpc.my_default_vpc, aws_security_group.my-kub-ec2-sg, data.aws_subnets.default_vpc_subnets ]

  tags = {
    name = each.key
  }
}