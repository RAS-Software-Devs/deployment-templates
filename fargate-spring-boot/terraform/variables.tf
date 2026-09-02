variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository" {
  description = "ECR repository name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "task_family" {
  description = "Task definition family name"
  type        = string
}

variable "db_secret_arn" {
  description = "Secrets Manager ARN holding RDS credentials, readable by the ECS execution role"
  type        = string
  default     = "arn:aws:secretsmanager:us-east-2:002356212742:secret:staging/rds/postgres-ORRDMm"
}

variable "auth_jwt_secret_arn" {
  description = "Secrets Manager ARN holding the user-authorization-service JWT signing secret"
  type        = string
  default     = "arn:aws:secretsmanager:us-east-2:002356212742:secret:prod/user-authorization-service/jwt-secret-55H5fL"
}

variable "vpc_cidr" {
  description = "CIDR block for new VPC (if creating)"
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}

variable "availability_zones" {
  description = "List of availability zones to use for subnets"
  type        = list(string)
  default     = []
}

variable "alb_name" {
  description = "Name for the Application Load Balancer"
  type        = string
  default     = "app-alb"
}

variable "desired_count" {
  description = "Number of Fargate tasks to run"
  type        = number
  default     = 1
}

variable "ecr_repository_user" {
  description = "ECR repository name for user authorization service"
  type        = string
  default     = "user-authorization-service-repo"
}

variable "ecr_repository_rental" {
  description = "ECR repository name for rental space service"
  type        = string
  default     = "rental-space-service-repo"
}

variable "task_family_user" {
  description = "Task family for user service"
  type        = string
  default     = "user-authorization-service"
}

variable "task_family_rental" {
  description = "Task family for rental service"
  type        = string
  default     = "rental-space-service"
}

variable "path_prefix_user" {
  description = "ALB path prefix for user service"
  type        = string
  default     = "/auth/*"
}

variable "path_prefix_rental" {
  description = "ALB path prefix for rental service"
  type        = string
  default     = "/api/*"
}
