output "vps_sg" {
  value       = aws_security_group.vps.id
  description = "vps sg"
}