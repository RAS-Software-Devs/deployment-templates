# Shared staging ALB

This CloudFormation stack owns the common HTTP entry point for staging. It creates one internal Application Load Balancer, listener rules, and one IP target group for each HTTP service.

Application repositories do not create load balancers, listeners, target groups, VPCs, or shared security-group rules. They build and publish their image, register an application task-definition revision, and update their existing ECS service. When an ECS service is initially provisioned, it attaches to the target-group ARN exported by this stack.

Routes:

- `/auth`, `/auth/*`, `/users`, and `/users/*` forward to `user-authorization-service` on port 8081.
- `/api` and `/api/*` forward to `rental-space-service` on port 8080.

Each ECS service has its own IP target group. The stack also permits HTTP access from the SSM-managed test host and authorization traffic from the ALB to the existing ECS task security group.

The ALB remains private. Use an SSM remote-host port-forwarding session and call `http://localhost:8081` from Bruno.

## Deploy

Use the `Deploy Shared Staging Infrastructure` workflow in this repository. Supply the existing staging VPC, two private subnets in different availability zones, the shared ALB security group, the ECS task security group, and the SSM test-host security group.

The workflow authenticates to AWS with GitHub OIDC and deploys the `ras-staging-shared-alb` CloudFormation stack. Configure the repository secret `AWS_ROLE_TO_ASSUME` with the ARN of the GitHub Actions role before running it.

For the current staging environment, the workflow inputs are:

| Input | Value |
| --- | --- |
| `vpc_id` | `vpc-096e3083cedfacc7b` |
| `subnet_ids` | `subnet-0f9f0d06b23f50b12,subnet-047e33d919e05da8f` |
| `alb_security_group_id` | `sg-0b0717699de878266` |
| `ecs_security_group_id` | `sg-0830d9c345d38b5f2` |
| `ssm_host_security_group_id` | `sg-0dcf98493f3b07a56` |

The workflow prints the private ALB DNS name and both target-group ARNs after a successful deployment.

## Ownership

This stack owns:

- The shared internal staging ALB.
- The HTTP listener and path-routing rules.
- The authorization and rental target groups.
- Shared ingress rules from the test host and ALB.

Each service deployment owns:

- Its ECR image and immutable image tag.
- Its ECS task definition and runtime secrets.
- Updating its ECS service to a new task-definition revision.
- Its application health and authentication behavior.

Do not run the application repositories' routine deployment workflows to create or modify this stack.