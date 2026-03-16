# Latest  Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Bastion Instance
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  subnet_id = var.public_subnet_ids[0]

  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = aws_key_pair.main.key_name

  # For direct SSH access
  associate_public_ip_address = true

  # Prevent from replacing the instance
  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name        = "${var.project_name}-bastion-${var.environment}"
    Environment = var.environment
  }
}
