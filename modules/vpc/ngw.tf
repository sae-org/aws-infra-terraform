# creating a ngw which will allow private subnets to talk to internet but no outside connection to that private subnet
# A public subnet is a subnet with a route to the internet via an Internet Gateway.
# The NAT Gateway needs this route to reach the internet — that's why it must live in a public subnet.
# But:
# Private instances do not talk directly to the internet — they talk to the NAT Gateway.
# The NAT Gateway is the one with internet access.

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip_ngw.id
  subnet_id     = values(aws_subnet.pub_sub)[0].id # pick first public subnet # will deploy in only one public subnet not both 

  tags = {
    Name = "${var.name}-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

