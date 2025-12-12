# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "wordpress_key" {
  key_name   = "${var.project_name}-key"
  public_key = file("C:/Users/abdul/.ssh/wordpress-key.pub")
}

resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.wordpress_key.key_name

  user_data = file("${path.module}/user-data.sh")

  monitoring = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  depends_on = [
    aws_nat_gateway.main
  ]

  tags = {
    Name = "${var.project_name}-wordpress-instance"
  }

  user_data_replace_on_change = true
}