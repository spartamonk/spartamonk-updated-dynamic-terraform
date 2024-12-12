module "network" {
  source     = "./modules/network"
  vpc_subnet = var.vpc_subnet
  subnets    = var.subnets

}

module "compute" {
  source            = "./modules/compute"
  instance          = var.instance
  private_subnet_id = module.network.private_subnet_id
  public_subnet_id  = module.network.public_subnet_id
  vpc_id            = module.network.vpc_id
  bastion_sg        = var.bastion_sg
  webserver_sg      = var.webserver_sg
  
}