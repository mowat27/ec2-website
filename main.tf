terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

data "aws_ami" "amzlinux2" {
  most_recent = true
  owners = ["amazon"] 
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }  
}

# -- Resources -----------------------------------------------------------------

# -- Instances

resource "aws_instance" "web_server" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.web_server_instance_type
  subnet_id = var.dmz_subnet

  key_name = var.aws_key_name

  associate_public_ip_address = true
  user_data = templatefile("user-data.sh", { 
    aws_region = var.aws_region 
    name = "Web Server"
  })


  vpc_security_group_ids = [
    aws_security_group.web_dmz.id
  ]

  tags = {
    Name = "Web Server"
  }
}

resource "aws_instance" "compute_server" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.compute_server_instance_type
  subnet_id = var.compute_subnet

  key_name = var.aws_key_name

  user_data = file("user-data.sh")
  vpc_security_group_ids = [
    aws_security_group.compute_tier.id
  ]

  tags = {
    Name = "Compute Server"
  }
}

# -- Security

resource "aws_security_group" "web_dmz" {
  name = "WebDMZ"
  description = "Allow web and ssh ingress and egress"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      aws_security_group.compute_tier.id
    ]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "compute_tier" {
  name = "Compute"
  description = "Allows ssh access to resources in the compute tier"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "web_internal_access" {
  description       = "Adds ssh from web servers to the compute tier"
  
  security_group_id = aws_security_group.compute_tier.id
  source_security_group_id = aws_security_group.web_dmz.id
  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}



