# 1) Generate key in Terraform
resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2) Register the PUBLIC key with EC2
resource "aws_key_pair" "dev_key_pub" {
  key_name   = "dev_key"
  public_key = tls_private_key.dev_key.public_key_openssh
}


# B) save private key in AWS Secrets Manager
resource "aws_secretsmanager_secret" "dev_key_priv" {
  name = "terraform/aws/ssh_key_priv"
}
resource "aws_secretsmanager_secret_version" "ans_priv_v1" {
  secret_id     = aws_secretsmanager_secret.dev_key_priv.id
  secret_string = tls_private_key.dev_key.private_key_pem
}
