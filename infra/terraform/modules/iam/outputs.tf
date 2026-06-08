output "instance_profile_name" {
  description = "IAM instance profile name — passed to EC2 module"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "role_name" {
  description = "IAM role name attached to the EC2 instance"
  value       = aws_iam_role.ec2_role.name
}

output "role_arn" {
  description = "IAM role ARN — use when wiring GitHub OIDC trust policy"
  value       = aws_iam_role.ec2_role.arn
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions OIDC role — set as AWS_ROLE_ARN in GitHub Secrets"
  value       = aws_iam_role.github_actions.arn
}
