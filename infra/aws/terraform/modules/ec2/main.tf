# vps
resource "aws_instance" "vps" {
  ami                         = "ami-05d62b9bc5a6ca605" # ubu 24.04, north-1
  instance_type               = "t3.micro"
  subnet_id                   = var.vps_subnet[0]
  vpc_security_group_ids      = [var.vps_sg]
  iam_instance_profile        = aws_iam_instance_profile.vps_profile.id
  associate_public_ip_address = true # нужно явно указывать, без него не работает ssm

  tags = {
    "Name" = "${var.deployment_prefix}-vps"
  }
}

# service role
resource "aws_iam_role" "vps_role" {
  name               = "vps_role_test"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
# for ssm access
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.vps_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# vps profile
resource "aws_iam_instance_profile" "vps_profile" {
  name       = "vps_profil_test"
  role       = aws_iam_role.vps_role.name
  depends_on = [aws_iam_role.vps_role]
}
# resource "aws_iam_role_policy_attachment" "s3-access" {
#   role       = aws_iam_role.vps_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }
