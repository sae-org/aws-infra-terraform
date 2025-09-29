# creating iam role for ec2 
resource "aws_iam_role" "iam_role" {
  name               = "${var.proj_prefix}-iam-role" 
  assume_role_policy = var.assume_role_policy
  tags = {
    Name = "${var.proj_prefix}-role"
  }
}

# creating an instance profile for ssm 
resource "aws_iam_instance_profile" "profile" {
  name = "${var.proj_prefix}-profile"
  role = aws_iam_role.iam_role.name
}

# creating policy for the ec2 role 
resource "aws_iam_role_policy" "role_policy" {
  name   = "${var.proj_prefix}-policy"
  role   = aws_iam_role.iam_role.id
  policy = var.role_policy
} 

# creating policy for ssm 
resource "aws_iam_role_policy_attachment" "attachment_policypolicy" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "${var.policy_attachment_1}-ssm"
}

resource "aws_iam_role_policy_attachment" "attachment_policy" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "${var.policy_attachment_2}-cw-agent"
}
