# WordPress Terraform Project

This project creates a complete WordPress environment on AWS using Terraform.

## Architecture

- VPC with public and private subnets
- EC2 instance in private subnet running WordPress
- Application Load Balancer in public subnet
- NAT Gateway for outbound internet access from private subnet
- Security groups for ALB and EC2

## Prerequisites

1. AWS CLI installed and configured
2. Terraform installed (v1.0+)
3. AWS IAM user with AdministratorAccess

## Usage

### Initialize Terraform
```bash
terraform init
```

### Validate Configuration
```bash
terraform validate
```

### Plan Deployment
```bash
terraform plan
```

### Deploy Infrastructure
```bash
terraform apply
```

### Get WordPress URL
```bash
terraform output wordpress_url
```

### Destroy Infrastructure
```bash
terraform destroy
```

## Accessing WordPress

After deployment (wait 5-10 minutes for WordPress installation):
1. Run `terraform output wordpress_url`
2. Open the URL in your browser
3. Complete WordPress setup wizard

## Files

- `provider.tf` - AWS provider configuration
- `variables.tf` - Input variables
- `vpc.tf` - VPC, subnets, routing
- `security_groups.tf` - Security group rules
- `ec2.tf` - EC2 instance configuration
- `alb.tf` - Application Load Balancer
- `outputs.tf` - Output values
- `user-data.sh` - EC2 initialization script

## Troubleshooting

Check target health:
```bash
aws elbv2 describe-target-health --target-group-arn <ARN>
```

Check EC2 instance:
```bash
aws ec2 describe-instances --instance-ids <ID>
```

## Security Notes

- EC2 instance is in private subnet (no direct internet access)
- Only ALB is publicly accessible
- Security groups restrict traffic appropriately
- Change default database password in variables.tf

## Cost Estimate

Running this infrastructure costs approximately:
- EC2 t2.micro: ~$8-10/month
- ALB: ~$16-20/month
- NAT Gateway: ~$32-45/month
- Total: ~$60-75/month

Remember to run `terraform destroy` when done testing!
