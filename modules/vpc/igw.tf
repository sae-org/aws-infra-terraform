# creating an IGW 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.proj_prefix}-igw"
  }
}