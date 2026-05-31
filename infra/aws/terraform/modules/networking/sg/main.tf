# vps sg
resource "aws_security_group" "vps" {
  name        = "vps-sg"
  description = "Sg for vps"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-vps-sg"
  }
}

resource "aws_security_group_rule" "port_open_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vps.id
}

resource "aws_security_group_rule" "port_open_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vps.id
}

resource "aws_security_group_rule" "access_to_internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vps.id
}
