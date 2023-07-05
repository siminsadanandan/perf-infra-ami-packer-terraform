output "vpc_id" {
  value       = aws_vpc.perf-loadgen.id
  description = "VPC id"
}

output "main_route_table_id" {
  value       = aws_vpc.perf-loadgen.main_route_table_id
  description = "Main route table id"
}
