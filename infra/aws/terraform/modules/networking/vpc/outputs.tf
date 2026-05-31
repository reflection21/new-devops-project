output "vpc_id" {
  value       = aws_vpc.main.id
  description = "vpc id"
}

output "public_subnet_id" {
  value       = [for s in aws_subnet.public : s.id]
  description = "public subnet id"
}

