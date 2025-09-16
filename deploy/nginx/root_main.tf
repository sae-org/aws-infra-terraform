# calling the aws provider from TF registry 
terraform {
  backend "s3" {

    bucket       = "dev-sae-tf-backend"
    key          = "terraform/nginx/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    # profile = "dev"
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
  # profile = "dev"
}

# module "iam" {
#   source        = "../../modules/iam"
#   iam_role_name = "ec2-role"
#   role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
#   ssm_profile_name = "SSMInstanceProfileDevNew2"
#   ec2_policy_name  = "ec2_policy"
#   ec2_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["ec2:RunInstances"]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#       {
#         Sid      = "Statement1"
#         Action   = ["ecr:*"]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
#   ssm_policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   cw_policy_arn  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

# }

# module "acm" {
#   source      = "../../modules/acm"
#   acm_domains = ["dev.saeeda.me", "moh.saeeda.me", "tee.saeeda.me"]
# }


# module "r53" {
#   source        = "../../modules/r53"
#   domain_name   = "saeeda.me"
#   create_domain = true
#   r53_domains = merge(
#     {
#       "alb.dev.saeeda.me" = [
#         {
#           name  = "dev.saeeda.me."
#           type  = "A"
#           value = null
#           alias = {
#             name                   = module.lb.lb_dns
#             zone_id                = module.lb.lb_zone
#             evaluate_target_health = false
#           }
#         }
#       ],
#       "alb.moh.saeeda.me" = [
#         {
#           name  = "moh.saeeda.me."
#           type  = "A"
#           value = null
#           alias = {
#             name                   = module.lb.lb_dns
#             zone_id                = module.lb.lb_zone
#             evaluate_target_health = false
#           }
#         }
#       ],
#       "alb.tee.saeeda.me" = [
#         {
#           name  = "tee.saeeda.me."
#           type  = "A"
#           value = null
#           alias = {
#             name                   = module.lb.lb_dns
#             zone_id                = module.lb.lb_zone
#             evaluate_target_health = false
#           }
#         }
#       ]
#     },
#     module.acm.domain_records # <- this is a map, merged in
#   )
# }


module "ec2" {
  source   = "../../modules/ec2"
  vpc_id   = module.vpc.vpc_id
  ins_type = "t2.micro"
  ami      = "ami-020cba7c55df1f615"
  # iam_ins_profile  = module.iam.ssm_profile
  pub_ip           = true
  subnet_ids       = module.vpc.pub_sub_id
  ec2_name         = "my-dev-ec2"
  public_key       = var.public_key
  desired_capacity = 2
  min_size         = 1
  max_size         = 3
}

# tg_arns          = module.lb.tg_arns

# module "lb" {
#   source          = "../../modules/lb"
#   security_groups = [module.ec2.sg_alb_id]
#   vpc_id          = module.vpc.vpc_id
#   name            = "my-dev-alb-1"
#   internal        = false
#   lb_type         = "application"
#   subnets         = module.vpc.pub_sub_id
#   ports = [
#     { port = 80, protocol = "HTTP" },
#     { port = 443, protocol = "HTTPS" }
#   ]
#   cert_arn            = module.acm.certificate_arns
#   primary_cert_domain = "dev.saeeda.me"
#   extra_certs         = ["moh.saeeda.me", "tee.saeeda.me"]
# }


module "vpc" {
  source     = "../../modules/vpc"
  cidr_block = "10.0.0.0/16"
  name       = "my-dev-vpc"
  vpc_az     = ["us-east-1a", "us-east-1b"]
}

# module "ecr" {
#   source   = "../../modules/ecr"
#   ecr_name = "my-dev-ecr-repo-1"
# }

module "monitoring" {
  source       = "../../modules/monitoring"
  sns_name     = "asg-cpu-alerts"
  display_name = "ASG CPU Alerts"
  alert_email  = "saeeda.devops@gmail.com"
  # asg_name     = module.ec2.asg_name

}

# module "github" {
#   source          = "../../modules/github"
#   git_name        = "CI-CD-Terraform-Dev-Repo-new"
#   git_description = "My ci/cd pipeline for terraform"
#   github_token    = 
# }


# output "debug_cert_arn_keys" {
#   value = keys(module.acm.certificate_arns)
# }

