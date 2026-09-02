# Fargate Spring Boot Template

This folder contains a reusable template for deploying a small Spring Boot service to AWS Fargate.

Contents:
- `fargate-deploy-template.yml` — example GitHub Actions workflow to build, push, and deploy to ECS (replace placeholders).
- `ecs-task-definition-template.json` — ECS task definition JSON with templated fields.
- `sample-starter/` — minimal Spring Boot starter app demonstrating CRUD operations (H2 in-memory DB) and a Dockerfile.

Usage:
1. Copy this folder into a new service repository or reference it as a submodule.
2. Replace placeholders in `fargate-deploy-template.yml` with your repo/cluster settings and add GH secrets:
   - `AWS_REGION`, `ECR_REGISTRY`, `ECR_REPOSITORY`, `ECS_CLUSTER`, `ECS_SERVICE`, `TASK_FAMILY`, `AWS_ROLE_TO_ASSUME`
3. Update `ecs-task-definition-template.json` with required CPU/memory and log group.
4. Use the sample starter to see where controllers, services, and repos go.

The `sample-starter` is intentionally minimal so new teams can copy files into their service and adapt.
