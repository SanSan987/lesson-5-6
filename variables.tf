variable "region" {
  description = "Регіон AWS, де розгортаємо інфраструктуру"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Назва нашої мережі (VPC)"
  type        = string
  default     = "my-education-vpc"
}

variable "vpc_cidr" {
  description = "Діапазон IP-адрес для VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
  default     = "my-education-cluster"
}