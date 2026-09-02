# Terraform for Fargate Spring Boot Template

This folder provides minimal Terraform to provision ECR, an ECS cluster, IAM roles (task execution and task role), and a CloudWatch log group for a Spring Boot service deployed to Fargate.

What it creates:
- `aws_ecr_repository` — container registry for the service
- `aws_ecs_cluster` — ECS cluster
- `aws_iam_role` + attachments — task execution role (allows pulling images/logging) and a task role
- `aws_cloudwatch_log_group` — log group for ECS tasks

What it does not create:
- VPC, subnets, security groups, or an ALB. Provide existing networking when creating services, or extend the Terraform before applying.

Quickstart:
1. Install Terraform 1.0+ and configure AWS credentials with permission to create the resources.
2. Customize `terraform.tfvars` or pass variables on the command line.

Example:
```bash
cd deployment-templates/fargate-spring-boot/terraform
terraform init
terraform apply -var="aws_region=us-east-1" -var="ecr_repository=my-app-repo" -var="ecs_cluster_name=my-app-cluster" -var="task_family=my-app"
```

After apply, use the output values to update your workflow and task definition template.
