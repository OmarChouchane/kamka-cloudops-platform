module "network" {
  source = "./modules/network"

  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
  allowed_ssh_cidr  = var.allowed_ssh_cidr
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "ec2" {
  source = "./modules/ec2"

  project_name         = var.project_name
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  subnet_id            = module.network.subnet_id
  security_group_id    = module.network.security_group_id
  iam_instance_profile = module.iam.instance_profile_name
}
