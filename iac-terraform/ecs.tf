resource "aws_ecs_task_definition" "node_app" {
  family                   = "node-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = <<DEFINITION
[
  {
    "image": "798745097403.dkr.ecr.us-east-1.amazonaws.com/pearlthoughts-ecr:latest",
    "cpu": 1024,
    "memory": 2048,
    "name": "node-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_cluster" "node_app_cluster" {
  name = "node-app-cluster"
}

resource "aws_ecs_service" "node_app_service" {
  name            = "node-app-service"
  cluster         = aws_ecs_cluster.node_app_cluster.id
  task_definition = aws_ecs_task_definition.node_app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.node_app_sg.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.id
    container_name   = "node-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.listener]
}