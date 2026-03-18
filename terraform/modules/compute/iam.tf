# IAM Role for  EC2
resource "aws_iam_role" "app_role" {
  name = "${var.project_name}-app-role-${var.environment}"

  # This allows EC2 to use this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-iam-role-${var.environment}"
  }
}

# Policy to access to SSM and Secrets
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile
resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.project_name}-app-profile-${var.environment}"
  role = aws_iam_role.app_role.name
}
