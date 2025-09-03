resource "aws_eip" "eip_ngw" {

  tags = {
    Name      = "${var.name}-eip_ngw"
  }
}