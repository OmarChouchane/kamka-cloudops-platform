output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Elastic IP address of the instance"
  value       = aws_eip.app.public_ip
}

output "public_dns" {
  description = "Public DNS name associated with the Elastic IP"
  value       = aws_eip.app.public_dns
}
