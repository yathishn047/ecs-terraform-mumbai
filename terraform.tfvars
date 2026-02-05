# Region & environment
aws_region       = "ap-south-1"

# ECS configuration
cluster_name    = "mumbai-ecs-cluster"
service_name    = "mumbai-ecs-service"
desired_count   = 1

#Container configuration
container_image = "amazon/amazon-ecs-nameTBD"

#Networking
vpc_id = "vpc-0fabc08a0a13fdf92"

subnet_ids = [
  "subnet-049211924ef7ebfaf", # ap-south-1a
  "subnet-092ab3c19026e2e53", # ap-south-1b
  "subnet-0792142b7adfe2bc6"  # ap-south-1c
]