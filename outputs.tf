output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private.id
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.wordpress.id
}

output "ec2_private_ip" {
  description = "EC2 Instance Private IP"
  value       = aws_instance.wordpress.private_ip
}

output "alb_dns_name" {
  description = "ALB DNS Name - Use this to access WordPress"
  value       = aws_lb.wordpress.dns_name
}

output "wordpress_url" {
  description = "WordPress URL"
  value       = "http://${aws_lb.wordpress.dns_name}"
}

output "nat_gateway_ip" {
  description = "NAT Gateway Public IP"
  value       = aws_eip.nat.public_ip
}

output "security_group_alb" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb.id
}

output "security_group_ec2" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2.id
}

output "instructions" {
  description = "Next steps"
  value       = <<-EOT
    
    ========================================
    WordPress Installation Complete!
    ========================================
    
    1. Wait 5-10 minutes for WordPress installation to complete
    2. Access WordPress at: http://${aws_lb.wordpress.dns_name}
    3. Complete WordPress setup wizard
    
    Database Credentials (if needed):
    - Database Name: wordpress_db
    - Database User: wp_user
    - Database Password: WordPress@456
    
    To SSH into the instance (if needed):
    - Use a bastion host or AWS Systems Manager Session Manager
    
    To destroy all resources when done:
    - Run: terraform destroy
    
    ========================================
  EOT
}