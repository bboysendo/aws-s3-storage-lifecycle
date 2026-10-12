variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name."
  type        = string
}

variable "project_name" {
  description = "Short name used as a tag for all resources."
  type        = string
  default     = "s3-lifecycle-lab"
}

variable "lifecycle_ia_transition_days" {
  description = "Days after creation before a current object transitions to Standard-IA."
  type        = number
  default     = 30
}

variable "lifecycle_glacier_transition_days" {
  description = "Days after creation before a current object transitions to Glacier Flexible Retrieval."
  type        = number
  default     = 90
}

variable "lifecycle_expiration_days" {
  description = "Days after creation before a current object is permanently expired (deleted)."
  type        = number
  default     = 365
}

variable "noncurrent_version_ia_days" {
  description = "Days after a version becomes noncurrent before it transitions to Standard-IA."
  type        = number
  default     = 30
}

variable "noncurrent_version_expiration_days" {
  description = "Days after a version becomes noncurrent before it is permanently deleted."
  type        = number
  default     = 90
}
