terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = "sae-org"
}

# resource "github_repository" "dev_repo" {
#   name        = "${var.proj_prefix}-"
#   description = var.git_description

#   visibility = "private"
# }

resource "github_actions_organization_secret" "ssh_private_key" {
  secret_name     = var.secret_name
  plaintext_value = var.key_text
  visibility      = "all"
}