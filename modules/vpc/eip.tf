resource "aws_eip" "eip_ngw" {

  tags = {
    Name = "${var.proj_prefix}-eip-ngw"
  }
}