resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key        = var.encryption_type == "KMS" ? var.kms_key : null
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.lifecycle_policy_enabled ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = jsonencode({ rules = var.lifecycle_policy_rules })
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.repository_policy_enabled ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy_json
}