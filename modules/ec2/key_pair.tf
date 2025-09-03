# created and added a new key pair which was then added to the instance ---------------------------------------------
resource "aws_key_pair" "newkey" {
  key_name   = "my-new-key-dev"
  public_key = var.public_key
}
