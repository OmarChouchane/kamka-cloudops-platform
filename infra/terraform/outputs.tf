# ─── Network ──────────────────────────────────────────────────────────────────

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = module.network.subnet_id
}

output "security_group_id" {
  description = "EC2 security group ID"
  value       = module.network.security_group_id
}

# ─── IAM ──────────────────────────────────────────────────────────────────────

output "iam_role_name" {
  description = "IAM role name attached to the EC2 instance"
  value       = module.iam.role_name
}

output "github_actions_role_arn" {
  description = "GitHub Actions OIDC role ARN — set as AWS_ROLE_ARN in GitHub Secrets"
  value       = module.iam.github_actions_role_arn
}

output "instance_profile_name" {
  description = "IAM instance profile name"
  value       = module.iam.instance_profile_name
}

# ─── EC2 ──────────────────────────────────────────────────────────────────────

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "Elastic IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = module.ec2.public_dns
}

output "ssh_command" {
  description = "Ready-to-use SSH command for the instance"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${module.ec2.public_ip}"
}
