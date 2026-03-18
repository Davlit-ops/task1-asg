module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  app_port     = var.app_port
}

module "compute" {
  source       = "./modules/compute"
  project_name = var.project_name
  environment  = var.environment

  vpc_id             = module.networking.vpc_id
  vpc_cidr           = var.vpc_cidr
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.app_private_subnet_ids

  bastion_sg_id = module.networking.bastion_sg_id
  alb_sg_id     = module.networking.alb_sg_id
  app_sg_id     = module.networking.app_sg_id

  app_port = var.app_port

  db_endpoint = module.database.db_endpoint
  db_password = module.database.db_password

}

module "database" {
  source = "./modules/database"

  project_name = var.project_name
  environment  = var.environment

  vpc_id                = module.networking.vpc_id
  db_private_subnet_ids = module.networking.db_private_subnet_ids

  rds_sg_id = module.networking.rds_sg_id
}
