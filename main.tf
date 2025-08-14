provider "aws" {
  region = "us-east-1"
}

module "ec2module" {
  source = "./EC2"
}

# Salida del módulo EC2
output "mainOutput" {
  value = module.ec2module.InsideModule
}

output "instance_public_ip" {
  value = module.ec2module.instance_public_ip
}

output "instance_id" {
  value = module.ec2module.key_pair_name
}