This Terraform configuration provisions an AWS ECS (Fargate) cluster and service in the Mumbai region (ap-south-1) and an SQS queue. It uses the default VPC and subnets in the account.

Quick start:

```bash
cd /home/dashloc/terraform-mumbai
terraform init
terraform plan -out plan.tfplan
terraform apply "plan.tfplan"
```

After apply, outputs will include the `ecs_cluster_id` and `sqs_queue_url`.

Notes:
- This configuration creates IAM roles allowing the task to access the SQS queue.
- If you need the ECS service to be reachable from the internet, adjust security groups and container port mappings accordingly.
