module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

module "compute" {
  source       = "./modules/compute"
  project_name = var.project_name
  environment  = var.environment

  vpc_id             = module.networking.vpc_id
  vpc_cidr           = var.vpc_cidr
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.app_private_subnet_ids

  app_port = var.app_port
}

module "database" {
  source = "./modules/database"

  project_name = var.project_name
  environment  = var.environment

  vpc_id                = module.networking.vpc_id
  db_private_subnet_ids = module.networking.db_private_subnet_ids
  app_sg_id             = module.compute.app_sg_id
}
