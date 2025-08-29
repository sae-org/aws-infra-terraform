# associating public subnet to rt1
resource "aws_route_table_association" "pubsub_rt" {
  for_each       = aws_subnet.pub_sub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.pub_rt.id
}

# associating private subnet to rt1
resource "aws_route_table_association" "prisub_rt" {
  for_each       = aws_subnet.pri_sub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.pri_rt.id
}