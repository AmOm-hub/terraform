# Copyright Amit Asman

output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.ec2_instances[*].public_ip
}

output "loadBalancer_DNS_name" {
  description = "DNS loadBalancer"
  value       = aws_lb.amit_ec2_lb.dns_name
}

output "key_pair_ssh_to_ec2" {
  description = "key pair in order to ssh the ec2 instances"
  value       = aws_lb.amit_ec2_lb.dns_name
}

