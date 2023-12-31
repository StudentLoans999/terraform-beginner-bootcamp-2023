variable "user_uuid" {
  description = "User UUID"
  type = string

  validation {
    condition = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message = "Invalid user UUID format. It should be in the form of 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' where x is a hexadecimal digit."
  }
}

/*variable "bucket_name" {
  description = "Name of the AWS S3 bucket"
  type = string

  validation {
    condition = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name length must be between 3 and 63 characters."
  }
}*/

variable "public_path" {
  description = "The file path for the public directory"
  type = string
}

variable "content_version" {
  type = number
  description = "Content version number (positive integer starting at 1)"

  validation {
    condition = var.content_version >= 1
    error_message = "Content version must be a positive integer starting at 1."
  }
}