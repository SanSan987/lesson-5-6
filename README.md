КЕРІВНИЦТВО (ІНСТРУКЦІЯ)
AWS EKS & VPC Infrastructure with Terraform
Цей проект автоматизує розгортання повноцінної хмарної інфраструктури в AWS. Він створює VPC (Virtual Private Cloud) та 
EKS (Elastic Kubernetes Service) кластер із двома групами нод, використовуючи модульний підхід Terraform.
Опис Завдання
Проект демонструє використання "Infrastructure as Code" (IaC) для створення:
-	VPC: Мережа з публічними та приватними підмережами, налаштованим NAT Gateway.
-	EKS Cluster: Керований Kubernetes кластер (версія 1.29).
Node Groups: Дві групи воркер-нод:
-	cpu_nodes: для загальних задач.
-	gpu_nodes: для специфічних задач (з відповідними лейблами, симуляція GPU).
Структура Проекту
Проект має модульну структуру:
Plaintext
eks-vpc-cluster/
├── main.tf            # Головний файл, що викликає модулі vpc та eks
├── variables.tf       # Кореневі змінні (регіон, назви)
├── outputs.tf         # Вивід корисних даних (команда для kubectl)
├── terraform.tf       # Налаштування версії Terraform
├── providers.tf       # Налаштування AWS провайдера
├── vpc/               # Локальний модуль мережі
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── eks/               # Локальний модуль кластера
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
Попередні вимоги (Prerequisites)
Перед запуску переконайтеся, що у вас встановлено:
Terraform (v1.0+)
AWS CLI (v2.0+)
kubectl
Також необхідно налаштувати доступ до AWS акаунту:
Bash
aws configure
# Введіть Access Key ID, Secret Access Key та регіон (us-east-1)
Інструкція із запуску (Quick Start)
1. Ініціалізація
Завантаження необхідних модулів та провайдерів:
Bash
terraform init
2. Перегляд плану
Перевірка ресурсів, які будуть створені:
Bash
terraform plan
3. Розгортання (Deploy)
Створення інфраструктури (процес займає 15-20 хвилин):
Bash
terraform apply -auto-approve
Підключення та Перевірка
Після успішного виконання terraform apply, виконайте команду, яку виведе Terraform у розділі Outputs, або скористайтеся шаблоном:
Оновлення конфігурації kubectl:
Bash
aws eks --region us-east-1 update-kubeconfig --name my-education-cluster
Перевірка нод:
Bash
kubectl get nodes
Очікуваний результат: 2 ноди зі статусом Ready.
Перевірка груп нод (Labels):
Bash
kubectl get nodes --show-labels
Очікуваний результат: Одна з нод повинна мати лейбл role=gpu-workload.
Налаштування (Variables)
Основні параметри можна змінити у файлі variables.tf:
Змінна	Опис	Значення за замовчуванням
region	AWS регіон	us-east-1
vpc_name	Назва мережі	my-education-vpc
cluster_name	Назва EKS кластера	my-education-cluster
________________________________________
Очищення ресурсів (Destroy)
ВАЖЛИВО: EKS кластер та NAT Gateway є платними ресурсами. Щоб уникнути зайвих витрат, після завершення роботи видаліть інфраструктуру:
Bash
terraform destroy -auto-approve
Дочекайтеся повідомлення: Destroy complete! Resources: N destroyed.



РЕЗУЛЬТАТИ ПЕРЕВІРКИ РОБОТИ КЛАСТЕРУ (з терміналу):

Apply complete! Resources: 63 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name my-education-cluster"

(base) PS C:\Users\sansa\eks-vpc-cluster> aws eks --region us-east-1 update-kubeconfig --name my-education-cluster
Added new context arn:aws:eks:us-east-1:848786564511:cluster/my-education-cluster to C:\Users\sansa\.kube\config
(base) PS C:\Users\sansa\eks-vpc-cluster> kubectl get nodes
NAME                         STATUS   ROLES    AGE   VERSION
ip-10-0-2-107.ec2.internal   Ready    <none>   16m   v1.29.15-eks-ecaa3a6
ip-10-0-2-135.ec2.internal   Ready    <none>   16m   v1.29.15-eks-ecaa3a6
(base) PS C:\Users\sansa\eks-vpc-cluster> kubectl get nodes --show-labels
NAME                         STATUS   ROLES    AGE   VERSION                LABELS
ip-10-0-2-107.ec2.internal   Ready    <none>   16m   v1.29.15-eks-ecaa3a6   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=t3.micro,beta.kubernetes.io/os=linux,eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/nodegroup-image=ami-081972d6202538cad,eks.amazonaws.com/nodegroup=gpu_nodes-2025112613235542570000001b,eks.amazonaws.com/sourceLaunchTemplateId=lt-09152c9d4ca5b006b,eks.amazonaws.com/sourceLaunchTemplateVersion=1,failure-domain.beta.kubernetes.io/region=us-east-1,failure-domain.beta.kubernetes.io/zone=us-east-1b,k8s.io/cloud-provider-aws=20530f3684b29ba036baafd8fb186fba,kubernetes.io/arch=amd64,kubernetes.io/hostname=ip-10-0-2-107.ec2.internal,kubernetes.io/os=linux,node.kubernetes.io/instance-type=t3.micro,role=gpu-workload,topology.kubernetes.io/region=us-east-1,topology.kubernetes.io/zone=us-east-1b
ip-10-0-2-135.ec2.internal   Ready    <none>   16m   v1.29.15-eks-ecaa3a6   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=t3.micro,beta.kubernetes.io/os=linux,eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/nodegroup-image=ami-081972d6202538cad,eks.amazonaws.com/nodegroup=cpu_nodes-20251126132355423800000019,eks.amazonaws.com/sourceLaunchTemplateId=lt-092080aeadaaff886,eks.amazonaws.com/sourceLaunchTemplateVersion=1,failure-domain.beta.kubernetes.io/region=us-east-1,failure-domain.beta.kubernetes.io/zone=us-east-1b,k8s.io/cloud-provider-aws=20530f3684b29ba036baafd8fb186fba,kubernetes.io/arch=amd64,kubernetes.io/hostname=ip-10-0-2-135.ec2.internal,kubernetes.io/os=linux,node.kubernetes.io/instance-type=t3.micro,topology.kubernetes.io/region=us-east-1,topology.kubernetes.io/zone=us-east-1b