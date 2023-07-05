output "public_subnet_id" {
  value       = aws_subnet.perf-loadgen-public-sn.id
  description = "Public Subnet id"
}

output "private_subnet_id" {
  value       = aws_subnet.perf-loadgen-private-sn.id
  description = "Private Subnet id"
}
