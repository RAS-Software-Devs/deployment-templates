locals {
  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${aws_ecr_repository.app.repository_url}:latest"
      essential = true
      portMappings = [ { containerPort = 8080, protocol = "tcp" } ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [ { name = "SPRING_PROFILES_ACTIVE", value = "prod" } ]
    }
  ])
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_role.arn
  container_definitions    = local.container_definitions
}

resource "aws_ecs_service" "app" {
  name            = var.task_family
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "app"
    container_port   = 8080
  }
  depends_on = [aws_lb_listener.http]
}

/* User service task and service */
locals {
  container_def_user = jsonencode([
    {
      name      = "user-app"
      image     = "${aws_ecr_repository.user.repository_url}:latest"
      essential = true
      portMappings = [ { containerPort = 8080, protocol = "tcp" } ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_user.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [ { name = "SPRING_PROFILES_ACTIVE", value = "prod" } ]
    }
  ])
}

resource "aws_ecs_task_definition" "user" {
  family                   = var.task_family_user
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_role.arn
  container_definitions    = local.container_def_user
}

resource "aws_ecs_service" "user" {
  name                       = var.task_family_user
  cluster                    = aws_ecs_cluster.main.id
  task_definition            = aws_ecs_task_definition.user.arn
  desired_count              = var.desired_count
  launch_type                = "FARGATE"
  health_check_grace_period_seconds = 300
  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tg_user.arn
    container_name   = "user-app"
    container_port   = 8080
  }
  depends_on = [aws_lb_listener.http]
  lifecycle {
    ignore_changes = [task_definition]
  }
}

/* Rental service task and service */
locals {
  container_def_rental = jsonencode([
    {
      name      = "rental-app"
      image     = "${aws_ecr_repository.rental.repository_url}:latest"
      essential = true
      portMappings = [ { containerPort = 8080, protocol = "tcp" } ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_rental.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [ { name = "SPRING_PROFILES_ACTIVE", value = "prod" } ]
    }
  ])
}

resource "aws_ecs_task_definition" "rental" {
  family                   = var.task_family_rental
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_role.arn
  container_definitions    = local.container_def_rental
}

resource "aws_ecs_service" "rental" {
  name                       = var.task_family_rental
  cluster                    = aws_ecs_cluster.main.id
  task_definition            = aws_ecs_task_definition.rental.arn
  desired_count              = var.desired_count
  launch_type                = "FARGATE"
  health_check_grace_period_seconds = 300
  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tg_rental.arn
    container_name   = "rental-app"
    container_port   = 8080
  }
  depends_on = [aws_lb_listener.http]
  lifecycle {
    ignore_changes = [task_definition]
  }
}
