# 🚀 AWS ECR Terraform Module

This Terraform module creates an **Amazon Elastic Container Registry (ECR)** repository with optional lifecycle and repository policies.

---

## 📦 Features

- Creates an ECR repository
- Supports:
  - Image tag mutability
  - Image scanning on push
  - Lifecycle policies
  - Repository access policies
- Fully customizable via variables

---

## 🛠️ Usage Example

```hcl
module "ecr" {
  source = "git::https://github.com/<your-username>/aws-modules.git//Terraform/modules/ecr?ref=main"

  name = "my-ecr-repo"

  tags = {
    environment = "dev"
    Owner       = "devops"
    UpdatedBy   = "Aslam"
  }

  lifecycle_policy_enabled = true

  lifecycle_policy_rules = [
    {
      rulePriority = 1
      description  = "Expire images older than 30 days"
      selection = {
        tagStatus   = "any"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = 30
      }
      action = {
        type = "expire"
      }
    }
  ]

  repository_policy_enabled = true

  repository_policy_json = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid       = "AllowPull"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy"
        ]
      }
    ]
  })
}
```

---

## 🔧 Input Variables

| Name                        | Type           | Default     | Description                                                |
| --------------------------- | -------------- | ----------- | ---------------------------------------------------------- |
| `name`                      | string         | n/a         | Name of the ECR repository                                 |
| `tags`                      | map(string)    | `{}`        | Tags to apply to the ECR repository                        |
| `image_tag_mutability`      | string         | `"MUTABLE"` | Whether tags can be overwritten (`MUTABLE` or `IMMUTABLE`) |
| `encryption_type`           | string         | `"AES256"`  | Encryption type for the repository (`AES256` or `KMS`)     |
| `kms_key`                   | string         | `null`      | ARN of the KMS key if using `KMS` encryption               |
| `scan_on_push`              | bool           | `true`      | Enables automatic scanning of images on push               |
| `lifecycle_policy_enabled`  | bool           | `false`     | Whether to attach a lifecycle policy                       |
| `lifecycle_policy_rules`    | list(any)      | `[]`        | List of lifecycle policy rules (only used if enabled)      |
| `repository_policy_enabled` | bool           | `false`     | Whether to attach a custom repository policy               |
| `repository_policy_json`    | string         | `""`        | JSON string defining repository access policies            |

---

## 📤 Outputs

| Name              | Description                               |
| ----------------- | ----------------------------------------- |
| `repository_arn`  | ARN of the created ECR repository         |
| `repository_url`  | URL of the ECR repository (for push/pull) |
| `repository_name` | Name of the ECR repository                |

---

## 🧠 Notes

- Lifecycle policy must follow ECR JSON format.
- Repository policy must follow IAM policy syntax.

---

## 🧪 Example Lifecycle Policy

```hcl
lifecycle_policy_rules = [
  {
    rulePriority = 1
    description  = "Expire untagged images older than 30 days"
    selection = {
      tagStatus   = "any"
      countType   = "sinceImagePushed"
      countUnit   = "days"
      countNumber = 30
    }
    action = {
      type = "expire"
    }
  }
]
```