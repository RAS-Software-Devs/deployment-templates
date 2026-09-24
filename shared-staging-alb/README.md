# Shared staging ALB

This CloudFormation stack owns the common HTTP entry point for staging. It creates one internal Application Load Balancer and its HTTP listener.

Application repositories do not create load balancers, listeners, VPCs, or shared access rules. Each service owns its target group, listener rule, ECS configuration, application image, and rollout workflow. Service stacks import the listener ARN exported by this stack.

Routes:

- `/auth`, `/auth/*`, `/users`, and `/users/*` forward to `user-authorization-service` on port 8081.
- `/api` and `/api/*` forward to `rental-space-service` on port 8080.

The stack permits HTTP access from the SSM-managed test host and shared ALB-to-ECS ingress. Service repositories attach their tasks to the exported shared ECS security group.

The ALB remains private. Use an SSM remote-host port-forwarding session and call `http://localhost:8081` from Bruno.

## Deploy

The `Deploy Shared Staging Infrastructure` workflow validates pull requests that change this directory. After those changes are merged or pushed to `main`, it automatically deploys the `ras-staging-shared-alb` stack. It can also be run manually with `workflow_dispatch` for recovery or reconciliation.

The workflow authenticates to AWS with GitHub OIDC and deploys the `ras-staging-shared-alb` CloudFormation stack. Configure the repository secret `AWS_ROLE_TO_ASSUME` with the ARN of the GitHub Actions role before running it.

The current staging resource IDs are versioned in `parameters/staging.json`:

| Input | Value |
| --- | --- |
| `vpc_id` | `vpc-096e3083cedfacc7b` |
| `subnet_ids` | `subnet-0f9f0d06b23f50b12,subnet-047e33d919e05da8f` |
| `alb_security_group_id` | `sg-0b0717699de878266` |
| `ecs_security_group_id` | `sg-0830d9c345d38b5f2` |
| `ssm_host_security_group_id` | `sg-0dcf98493f3b07a56` |

The workflow prints the private ALB DNS name and both target-group ARNs after a successful deployment.

Changes elsewhere in `deployment-templates` do not redeploy this stack. Add another path-scoped workflow for each independently owned infrastructure stack so unrelated updates cannot mutate staging resources.

## Ownership

This stack owns:

- The shared internal staging ALB.
- The HTTP listener and default response.
- Shared ingress from the SSM test host and ALB to ECS tasks.

Each service deployment owns:

- Its ECR image and immutable image tag.
- Its target group and listener rule.
- Its ECS task definition and runtime secrets.
- Updating its ECS service to a new task-definition revision.
- Its application health and authentication behavior.

Do not run the application repositories' routine deployment workflows to create or modify this stack.