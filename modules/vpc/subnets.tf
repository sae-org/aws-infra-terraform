# creating a public subnet for vpc 
resource "aws_subnet" "pub_sub" {
  for_each = toset(var.vpc_az)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, index(var.vpc_az, each.value) + 1) #cidrsubnet a built in TF func that will create subnets from larger cidr which is in vpc cidr block. Takes three params: 1st = cidr block of vpc, 2nd = newbits, 3rd = newnum (kodedge aws vpc lec 4)
  availability_zone = each.value

  tags = {
    Name = "${var.proj_prefix}-public-subnet"
  }
}

# creating a private subnet for vpc
resource "aws_subnet" "pri_sub" {
  for_each = toset(var.vpc_az)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, index(var.vpc_az, each.value) + 3) #cidrsubnet a built in TF func that will create subnets from larger cidr which is in vpc cidr block. Takes three params: 1st = cidr block of vpc, 2nd = newbits, 3rd = newnum (kodedge aws vpc lec 4)
  availability_zone = each.value

  tags = {
    Name = "${var.proj_prefix}-private-subnet"
  }
}