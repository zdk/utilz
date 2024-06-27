resource "aws_ecr_repository" "app" {
  count = "${var.ecr_repo != "" ? 1 : 0}"
  name = "${var.ecr_repo}"
}

resource "aws_ecs_cluster" "ecs" {
  name = "${var.cluster_name}"
}

resource "aws_autoscaling_group" "ecs_instance_autoscaling" {
  name                 = "${var.cluster_name}-ecs-instance-autoscaling"
  vpc_zone_identifier  = "${var.subnets}"
  launch_configuration = "${aws_launch_configuration.ecs_launch_configuration.name}"

  min_size             = "${var.autoscale_min_size}"
  max_size             = "${var.autoscale_max_size}"
  desired_capacity     = "${var.autoscale_desired_size}"

  tag {
      key = "Name"
      value = "ecs-instance-container"
      propagate_at_launch = true
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"

  vars {
    cluster_name = "${var.cluster_name}"
  }
}


resource "aws_security_group" "instance_sg" {
  description = "controls direct access to application instances"
  vpc_id      = "${var.vpc_id}"
  name        = "ecs-instance-sg"

  ingress {
      from_port = 0
      to_port = 0
      protocol = -1
      self = true
  }

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80

    security_groups = [
      "${aws_security_group.lb_sg.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "ecs_launch_configuration" {
  security_groups = [
    "${aws_security_group.instance_sg.id}",
  ]

  name_prefix          = "${var.cluster_name}-launch-configuration"
  image_id             = "ami-050865a806e0dae53"
  instance_type        = "${var.instance_type}"
  #iam_instance_profile = "${aws_iam_instance_profile.ecs_instance_profile.id}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_ec2_instance_profile.id}"
  user_data            = "${data.template_file.user_data.rendered}"
  #user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=${var.cluster_name}' > /etc/ecs/ecs.config\nstart ecs"
	key_name             = "${aws_key_pair.deployer.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.cluster_name}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}


resource "aws_iam_instance_profile" "ecs_ec2_instance_profile" {
    name = "ecs-ec2-instance-profile"
    role = "${aws_iam_role.ecs-ec2-role.name}"
}

resource "aws_iam_role" "ecs-ec2-role" {
    name = "ecs-ec2-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_ec2_role_policy" {
    name = "ecs-ec2-role-policy"
    role = "${aws_iam_role.ecs-ec2-role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}
