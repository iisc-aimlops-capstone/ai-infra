resource "aws_security_group" "ai_sg" {
    name        = var.alb_sg_name
    description = var.alb_sg_desc
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8501
        to_port     = 8501
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
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
        Name = var.alb_sg_name
        CreatedBy   = "Terraform"
        Project     = var.project
    }
}

resource "aws_lb" "ai_alb" {
    name               = var.alb_name
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.ai_sg.id]
    subnets            = var.subnet_ids

    enable_deletion_protection = false

    tags = {
        Name        = var.alb_name
        CreatedBy   = "Terraform"
        Project     = var.project
    }
}



resource "aws_lb_listener" "https_listener" {
    load_balancer_arn = aws_lb.ai_alb.arn
    port              = 443
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = var.certificate_arn

    default_action {
        type             = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "Not Found"
            status_code  = "404"
        }
  }

    tags = {
        Name        = "${var.alb_name}-listener"
        CreatedBy   = "Terraform"
        Project     = var.project
    }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ai_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "frontend_rule" {
    listener_arn = aws_lb_listener.https_listener.arn
    priority     = 10

    action {
        type             = "forward"
        target_group_arn = var.fe_tg_arn
    }

    condition {
        path_pattern {
            values = ["/app*"]
        }
    }
}


resource "aws_lb_listener_rule" "backend_rule" {
    listener_arn = aws_lb_listener.https_listener.arn
    priority     = 20

    action {
        type             = "forward"
        target_group_arn = var.be_tg_arn
    }

    condition {
        path_pattern {
            values = ["/api/*"]
        }
    }
}