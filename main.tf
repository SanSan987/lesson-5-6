# Виклик модуля VPC
module "vpc" {
  source = "./vpc"

  # беремо значення зі змінних (var.)
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  
  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}

# Виклик модуля EKS
module "eks" {
  source = "./eks"

  # Беремо назву зі змінної
  cluster_name = var.cluster_name
  
  # ПЕРЕДАЧА ДАНИХ: Беремо outputs з модуля VPC і передаємо в EKS
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}