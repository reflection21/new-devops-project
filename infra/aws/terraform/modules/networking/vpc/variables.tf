variable "vpc_cidr_block" {
  type = string
}

variable "deployment_prefix" {
  type = string
}

variable "public_subnet_cidr" {
  type = list(string)
}
