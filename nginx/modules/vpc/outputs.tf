output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pri_sub_id" {
  value = [for az in var.vpc_az : aws_subnet.pri_sub[az].id]
}

output "pub_sub_id" {
  value = [for az in var.vpc_az : aws_subnet.pub_sub[az].id]
}

