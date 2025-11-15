provider "aws" {
  region = "eu-central-1"
  profile = "with"
}


module "web_server" {
  source = "./modules/web-server"

  vpc_id = var.vpc_id
  subnet_id = var.subnet_id
  list_of_open_ports = var.list_of_open_ports
}