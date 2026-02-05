data "aws_vpc" "existing" {
  id = var.vpc_id
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.existing.id
}

resource "aws_sqs_queue" "mumbai_queue" {
  name                      = "mumbai-ecs-queue"
  visibility_timeout_seconds = 30
}

resource "aws_ecs_cluster" "mumbai" {
  name = var.cluster_name
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = 14
}

resource "aws_iam_role" "execution_role" {
  name = "${var.cluster_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "execution_attach" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name = "ecsTaskRole-mumbai"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "task_sqs_policy" {
  name = "ecs-task-sqs-policy-mumbai"
  role = aws_iam_role.task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility"
        ]
        Resource = aws_sqs_queue.mumbai_queue.arn
      }
    ]
  })
}



resource "aws_ecs_task_definition" "app" {
  family                   = "mumbai-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "4096"
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.container_image
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        { name = "SQS_QUEUE_URL", value = aws_sqs_queue.mumbai_queue.url }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.mumbai.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.execution_attach]
}