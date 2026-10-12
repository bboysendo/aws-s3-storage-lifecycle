output "bucket_name" {
  description = "Name of the documents bucket."
  value       = aws_s3_bucket.documents.id
}

output "bucket_arn" {
  description = "ARN of the documents bucket."
  value       = aws_s3_bucket.documents.arn
}
