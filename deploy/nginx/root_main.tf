# calling the aws provider from TF registry 
terraform {
  backend "s3" {

    bucket       = "dev-sae-tf-backend"
    key          = "terraform/nginx/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# configuring aws provider 
provider "aws" {
  region = "us-east-1"
}

module "iam" {
  source        = "../../modules/iam"
  proj_prefix = "my-website"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid      = "Statement1"
        Action   = ["ecr:*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
  policy_attachment_1 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  policy_attachment_2 = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

module "acm" {
  source      = "../../modules/acm"
  acm_domains = ["saeeda.me"]
}


module "r53" {
  source        = "../../modules/r53"
  domain_name   = "saeeda.me"
  create_domain = true
  r53_domains = merge(
    {
      "alb.saeeda.me" = [
        {
          name  = "saeeda.me."
          type  = "A"
          value = null
          alias = {
            name                   = module.lb.lb_dns
            zone_id                = module.lb.lb_zone
            evaluate_target_health = false
          }
        }
      ],
    },
    module.acm.domain_records # <- this is a map, merged in
  )
}


module "ec2" {
  source           = "../../modules/ec2"
  proj_prefix = "my-website"
  vpc_id           = module.vpc.vpc_id
  ins_type         = "t2.micro"
  ami              = "ami-020cba7c55df1f615"
  iam_ins_profile  = module.iam.ec2_profile
  pub_ip           = true
  subnet_ids       = module.vpc.pub_sub_id
  desired_capacity = 2
  min_size         = 2
  max_size         = 3
  user_data        = file("${path.root}/user_data.sh")
  tg_arns          = module.lb.tg_arns
}

module "lb" {
  source          = "../../modules/lb"
  proj_prefix = "my-website"
  security_groups = [module.ec2.sg_alb_id]
  vpc_id          = module.vpc.vpc_id
  internal        = false
  lb_type         = "application"
  subnets         = module.vpc.pub_sub_id
  ports = [
    { port = 80, protocol = "HTTP" },
    { port = 443, protocol = "HTTPS" }
  ]
  cert_arn            = module.acm.certificate_arns
  primary_cert_domain = "saeeda.me"
}


module "vpc" {
  source     = "../../modules/vpc"
  proj_prefix = "my-website"
  cidr_block = "10.0.0.0/16"
  vpc_az     = ["us-east-1a", "us-east-1b"]
}

module "ecr" {
  source   = "../../modules/ecr"
  proj_prefix = "my-website"

}

module "monitoring" {
  source       = "../../modules/monitoring"
  proj_prefix = "my-website"
  display_name = "ASG CPU Alerts"
  alert_email  = "saeeda.devops@gmail.com"
  asg_name     = module.ec2.asg_name
}
data "aws_secretsmanager_secret_version" "github_token" {
  secret_id     = "arn:aws:secretsmanager:us-east-1:886687538523:secret:tf-token-8tPNJS"
  version_stage = "AWSCURRENT" # get the active value 
}

locals {
  raw_secret     = data.aws_secretsmanager_secret_version.github_token.secret_string
  decoded_secret = trimspace(jsondecode(local.raw_secret).Token)
}
module "github" {
  source       = "../../modules/github"
  github_token = local.decoded_secret
  secret_name  = "ASG_SSH_KEY"
  key_text     = module.ec2.tls_private_key
}


