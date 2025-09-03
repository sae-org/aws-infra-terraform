terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = "Saeeda14"
}

resource "github_repository" "dev_repo" {
  name        = var.git_name
  description = var.git_description

  visibility = "private"
}