output "ec2_instance_public_ip" {
  value       = aws_instance.perf-loadgen[*].public_ip
  description = "EC2 Instance public ip"
}

output "ec2_instance_private_ip" {
  value       = aws_instance.perf-loadgen[*].private_ip
  description = "EC2 Instance private ip"
}
