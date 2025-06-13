variable "name" {
  type        = string
  description = "The name of the ECR repository."
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "The tag mutability setting for the repository."
}

variable "encryption_type" {
  type        = string
  default     = "AES256"
  description = "The encryption type for the repository. Valid values are 'AES256' or 'KMS'."
}

variable "kms_key" {
  type        = string
  default     = null
  description = "The ARN of the KMS key to use when encryption_type is 'KMS'."
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "Indicates whether images are scanned after being pushed to the repository."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the resource."
}

variable "lifecycle_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable the lifecycle policy."
}

variable "lifecycle_policy_rules" {
  type = list(any)
  default = []
  description = "A list of lifecycle policy rules for the repository."
}

variable "repository_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable the repository policy."
}

variable "repository_policy_json" {
  type        = string
  default     = ""
  description = "The JSON policy to apply to the repository."
}