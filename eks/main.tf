module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true

  # Підключаємо до VPC, яку створили в сусідньому модулі
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Дозволяє поточному користувачу керувати кластером
  enable_cluster_creator_admin_permissions = true

  # Node Groups (Групи нод)
  eks_managed_node_groups = {
    # Група для загальних задач (CPU)
    cpu_nodes = {
      min_size     = 1
      max_size     = 5
      desired_size = 4

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
    }

    # Група для "GPU"
    gpu_nodes = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.micro"]
      
      # Додаємо лейбли, щоб Kubernetes знав, що це "особливі" ноди
      labels = {
        role = "gpu-workload"
      }
      
      # Taint, щоб сюди потрапляли лише специфічні поди (опціонально)
      taints = {
        dedicated = {
          key    = "workload"
          value  = "gpu"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

    tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}