resource "aws_ecs_cluster" "lzb-project-ecs" {
  name = "lzb-project-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "lzb-project-task" {
  family                   = "lzb-project-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "654654440523.dkr.ecr.ap-south-1.amazonaws.com/lzb-project-repo:latest"
      essential = true

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name,
          awslogs-region        = "eu-west-1",
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "lzb-project-svc" {
  name            = "lzb-project-service"
  cluster         = aws_ecs_cluster.lzb-project-ecs.id
  task_definition = aws_ecs_task_definition.lzb-project-task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = module.vpc.public_subnets[*]
    security_groups  = [aws_security_group.public-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = local.container_name
    container_port   = 80
  }

  depends_on = [aws_lb_listener.listener]

}