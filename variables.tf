# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

###AWS#########################################################################

variable "aws_region" {
  description = "region"
  type        = string
  default     = "us-west-2"
}

###VPC#########################################################################

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "amit-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

###EC2#########################################################################

variable "ec2_ami" {
  description = "ami that is used in EC2"
  type        = string
  default     = "ami-0c5204531f799e0c6"
}

variable "ec2_instance_type" {
  description = "instance type"
  type        = string
  default     = "t3a.micro"
}

variable "ec2_count" {
  description = "number of instances"
  type        = number
  default     = 2
}

###TAGS########################################################################

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Name            = "amit"
    Owner           = "amit"
    bootcamp        = "int_bootcamp"
    expiration_date = "30-02-23"
  }
}
