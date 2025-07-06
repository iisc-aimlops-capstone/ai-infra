# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "ec2_sg" {
    name        = var.ec2_sg_name
    description = var.ec2_sg_desc
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.ec2_sg_name
        CreatedBy   = "Terraform"
        Project     = var.project
    }
}

resource "aws_instance" "amazon_linux" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id # Replace with your subnet ID
  vpc_security_group_ids      = ["${aws_security_group.ec2_sg.id}"]   # Replace with your security group ID
  associate_public_ip_address = true
  key_name                    = var.key_name # Replace with your EC2 key pair

  root_block_device {
    volume_size = 20        # Size in GB
    volume_type = "gp3"     # Use gp3 instead of gp2 (recommended)
    delete_on_termination = true
  }

  tags = {
    Name = var.ec2_instance_name
    Project = var.project
    CreatedBy = "Terraform"
  }
}