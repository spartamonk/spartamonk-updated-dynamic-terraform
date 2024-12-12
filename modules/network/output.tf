output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = local.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = local.private_subnet_id
}