packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type        = string
  description = "AWS Region to build the AMI in"
  default     = "us-east-2"
}

variable "ami_prefix" {
  type        = string
  description = "Prefix for the AMI name"
  default     = "task1-llm-ami"
}

# For unique AMI naming
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# Define the builder
source "amazon-ebs" "ubuntu" {
  ami_name = "${var.ami_prefix}-${local.timestamp}"

  instance_type = "t3.medium"
  region        = var.region
  ssh_username  = "ubuntu"

  # fix  for the memory
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  # The latest official Ubuntu 24.04 LTS image
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }

  tags = {
    Name        = "${var.ami_prefix}-${var.region}"
    Environment = "dev"
    ManagedBy   = "packer"
  }
}

# Define the provisioning steps
build {
  name = "llm-builder"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "open-webui.service"
    destination = "/tmp/open-webui.service"
  }

  # Install Ollama, pull TinyLlama, and pull OpenWebUI image
  provisioner "shell" {
    script = "setup_llm.sh"
  }
}
