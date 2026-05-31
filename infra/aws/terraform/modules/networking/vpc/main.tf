# main vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default" # общий сервер для всех клиентов 
  enable_dns_support   = "true"    # включает DNS резолвинг для серверов в vps
  enable_dns_hostnames = "true"    # давать ли инстансам имена внутри DNS

  tags = {
    Name = "${var.deployment_prefix}-vpc"
  }
}
# public subnets
resource "aws_subnet" "public" {
  count                                       = length(var.public_subnet_cidr)
  vpc_id                                      = aws_vpc.main.id
  cidr_block                                  = var.public_subnet_cidr[count.index]
  availability_zone                           = data.aws_availability_zones.az.names[count.index]
  enable_resource_name_dns_a_record_on_launch = "true"          # создавать ли автоматические DNS A-записи для инстансов при запуске
  private_dns_hostname_type_on_launch         = "resource-name" # из чего будет состоять DNS-имя инстанса внутри VPC — из IP или из ID ресурса
  tags = {
    Name = "${var.deployment_prefix}-public-subnet-${count.index + 1}"
  }
}
# igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.deployment_prefix}-igw"
  }
}
# public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "${var.deployment_prefix}-public-rt"
  }
}
# link public-rt to pubclic subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
