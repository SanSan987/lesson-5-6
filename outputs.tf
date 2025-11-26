output "configure_kubectl" {
  description = "Команда для налаштування доступу до кластера"
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
}