resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.proj_prefix}-ecr-repo"
  image_tag_mutability = "MUTABLE" # This controls whether Docker image tags in your ECR repository can be overwritten after an image has already been pushed. # MUTABLE = You can reuse or overwrite tags. # IMMUTABLE = Once an image is pushed with a tag, you cannot push another image with the same tag.

  image_scanning_configuration {
    scan_on_push = true # scan_on_push = true # Every time you push a new image to this repository, Amazon ECR will trigger a vulnerability scan automatically. # The scan uses Amazon Inspector under the hood. It checks for known Common Vulnerabilities and Exposures (CVEs) in the OS packages and software libraries inside the image.
  }
}