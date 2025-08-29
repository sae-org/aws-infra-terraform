# creating a route table for public subnet 
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" # anyone can access public subnet (web) and its attached to igw used for public access
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name      = "${var.name}-pub_rt1"
  }
}

# creating a route table for private subnet, not adding any specific rule, just attaching it to VPC
resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0" # anyone can access internet and routed via ngw 
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name      = "${var.name}-pri_rt1"
  }
}