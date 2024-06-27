resource "aws_security_group" "lb_sg" {
  vpc_id = "${var.vpc_id}"
  name   = "ecs-lb-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_ecs_service" "service" {
  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs_tg.arn}"
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
  }

  name            = "website"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.ecs_rails_task_definition.*.arn[0]}"

  depends_on = [
    "aws_iam_policy_attachment.ecs-service-attach",
    "aws_alb_target_group.ecs_tg",
  ]

  iam_role = "${aws_iam_role.ecs_service_role.arn}"

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}

resource "aws_ecs_service" "background_service" {
  name            = "sidekiq"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.ecs_rails_task_definition.*.arn[3]}"
  desired_count   = 1

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}

resource "aws_iam_role" "ecs_service_role" {
  name = "ecs-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs-service-attach" {
  name       = "ecs-service-attach"
  roles      = ["${aws_iam_role.ecs_service_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_alb_target_group" "ecs_tg" {
  depends_on = ["aws_alb.main"]
  name       = "ecs-alb-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = "${var.vpc_id}"
}

resource "aws_alb" "main" {
  name            = "ecs-alb"
  subnets         = ["${var.subnets}"]
  security_groups = ["${aws_security_group.lb_sg.id}"]
}

resource "aws_alb_listener" "ecs_alb_listener" {
  depends_on = ["aws_alb.main"]

  load_balancer_arn = "${aws_alb.main.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs_tg.id}"
    type             = "forward"
  }
}

# resource "aws_lb_listener" "https" {
#   count             = "${var.https_enabled == "true" ? 1 : 0}"
#   load_balancer_arn = "${aws_lb.default.arn}"
#
#   port            = "${var.https_port}"
#   protocol        = "HTTPS"
#   ssl_policy      = "ELBSecurityPolicy-2015-05"
#   certificate_arn = "${var.certificate_arn}"
#
#   default_action {
#     target_group_arn = "${aws_lb_target_group.default.arn}"
#     type             = "forward"
#   }
# }

