resource "aws_lb_target_group" "fe" {
    name     = var.fe_tg_name
    port     = 8501
    protocol = "HTTP"
    target_type = "ip"
    vpc_id   = var.vpc_id

    health_check {
        path                = "/app"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200-399"
    }

    tags = {
        Name        = var.fe_tg_name
        CreatedBy   = "Terraform"
        Project     = var.project
    }
}

resource "aws_lb_target_group" "be" {
    name     = var.be_tg_name
    port     = 8000
    protocol = "HTTP"
    target_type = "ip"
    vpc_id   = var.vpc_id

    health_check {
        path                = "/docs"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200-399"
    }

    tags = {
        Name        = var.be_tg_name
        CreatedBy   = "Terraform"
        Project     = var.project
    }
}