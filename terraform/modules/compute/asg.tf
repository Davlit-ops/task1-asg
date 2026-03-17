# Golden AMI built by Packer
data "aws_ami" "llm_image" {
  most_recent = true
  owners      = ["self"] # owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["task1-llm-ami-*"] # values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]  next step values = ["${var.project_name}-llm-ami-*"]
  }
}

# Template for new LLM EC2
resource "aws_launch_template" "app" {
  # Preventing problems with names
  name_prefix = "${var.project_name}-launch-template-"
  image_id    = data.aws_ami.llm_image.id

  # large for llm but need to test
  instance_type = "t3.large"

  key_name = aws_key_pair.main.key_name

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(templatefile("${path.module}/userdata.sh.tftpl", {
    db_endpoint = var.db_endpoint
    db_password = var.db_password
  }))

  iam_instance_profile {
    name = aws_iam_instance_profile.app_profile.name
  }

  # Tag the instances
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-llm-node-${var.environment}"
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name = "${var.project_name}-asg-${var.environment}"

  # ONLY in the private subnets
  vpc_zone_identifier = var.private_subnet_ids

  # ASG to the ALB
  target_group_arns = [aws_lb_target_group.app.arn]

  desired_capacity = 2 # one in each AZ
  min_size         = 2
  max_size         = 4 # Allow scaling

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # replacing during updates
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# Add/remove instances based on CPU
resource "aws_autoscaling_policy" "cpu_tracking" {
  name                   = "${var.project_name}-cpu-policy-${var.environment}"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
