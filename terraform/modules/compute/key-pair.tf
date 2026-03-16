resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key-${var.environment}"
  public_key = file("${path.root}/../task1.pem.pub")
}
