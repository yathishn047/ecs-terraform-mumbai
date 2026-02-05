variable "aws_region" {
  description = "AWSto create resources in Mumbai region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "mumbai-ecs-cluster"
}

variable "service_name" {
  description = "ECS service name"
  type        = string
  default     = "mumbai-ecs-service"
}

variable "desired_count" {
  description = "Number of desired tasks"
  type        = number
  default     = 1
}

variable "container_image" {
  description = "Container image for the task"
  type        = string
  default     = "amazon/amazon-ecs-sample"
}

variable "vpc_id" {
  description = "existing VPC ID to deploy resources into"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where ECS Fargate tasks will run"
  type        = list(string)
}

