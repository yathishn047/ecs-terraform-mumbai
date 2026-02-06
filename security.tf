resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg-mumbai"
  description = "Allow outbound access for ECS tasks"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
    description = "No inbound by default"
  }
}