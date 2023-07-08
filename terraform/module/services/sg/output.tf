output "vpc_security_group_ids" {
  value       = aws_security_group.perf-loadgen.id
  description = "Security group id"
}
