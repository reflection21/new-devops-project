terraform {
  source = "../../../terraform/modules/ec2/"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true # include variables of parents file
}

dependency "sg" {
  config_path = "../networking/sg"
}

dependency "vpc" {
  config_path = "../networking/vpc"
}

inputs = {
  vps_subnet = dependency.vpc.outputs.public_subnet_id
  vps_sg     = dependency.sg.outputs.vps_sg
}