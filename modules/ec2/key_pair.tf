# # created and added a new key pair which was then added to the instance ---------------------------------------------
resource "aws_key_pair" "newkey" {
  key_name   = "ansible-test-git"
  public_key = var.public_key
}
