# Copyright Amit

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "3.18.1"
  name               = var.vpc_name
  cidr               = var.vpc_cidr
  azs                = var.vpc_azs
  public_subnets     = var.vpc_public_subnets
  enable_nat_gateway = var.vpc_enable_nat_gateway
  tags               = var.tags
}

module "ec2_instances" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "4.3.0"
  count                  = var.ec2_count
  name                   = "amit-ec2-${count.index}"
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  tags                   = var.tags
}

module "website_s3_bucket" {
  source      = "./modules/aws-s3-static-website-bucket"
  bucket_name = "amit-test-21.02.2023"
  tags        = var.tags
}

resource "aws_lb" "amit_ec2_lb" {
  name               = "amit-ec2-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.amit_lb_sg.id]
  subnets            = module.vpc.public_subnets
  tags               = var.tags
}

resource "aws_lb_target_group" "amit_ec2_tg" {
  name_prefix = "ec2-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id

  tags = var.tags
}

resource "aws_lb_listener" "amit_ec2_listener" {
  load_balancer_arn = aws_lb.amit_ec2_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.amit_ec2_tg.arn
    type             = "forward"
  }
}

resource "aws_security_group" "amit_ec2_sg" {
  name_prefix = "amit_ec2-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.amit_lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "amit_lb_sg" {
  name_prefix = "amit_lb-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}


