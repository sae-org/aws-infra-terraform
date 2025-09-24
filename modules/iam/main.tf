# creating iam role for ec2 
resource "aws_iam_role" "iam_role" {
  name               = var.iam_role_name #ec2-role
  assume_role_policy = var.role_policy
  tags = {
    Name = var.iam_role_name
  }
}

# creating an instance profile for ssm 
resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.ec2_profile_name
  role = aws_iam_role.iam_role.name
}

# creating policy for the ec2 role 
resource "aws_iam_role_policy" "ec2_policy" {
  name   = var.ec2_policy_name
  role   = aws_iam_role.iam_role.id
  policy = var.ec2_policy
}

# creating policy for ssm 
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = var.ssm_policy_arn
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.iam_role.name
  policy_arn = var.cw_policy_arn
}
