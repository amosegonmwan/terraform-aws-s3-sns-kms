# Terraform state storage  bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.team}-${random_pet.bucket_name.id}-${random_integer.bucket_int.result}"

  tags = {
    Name        = var.my_bucket
    Environment = var.env
  }
}

resource "random_pet" "bucket_name" {
  prefix = "wemadevops"
  length = 2
}

resource "random_integer" "bucket_int" {
  max = 500
  min = 1
}

resource "aws_sns_topic" "topic" {
  name              = var.topic_name
  policy            = data.aws_iam_policy_document.topic.json
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}
 
resource "aws_sns_topic_subscription" "email" {
  endpoint  = "name.name@example.com"
  protocol  = "email"
  topic_arn = aws_sns_topic.topic.arn
}


resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.status
  }
}


resource "aws_kms_key" "mykmskey" {
  description             = "An example symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  }


resource "aws_kms_key_policy" "mykmskey-policy" {
  key_id = aws_kms_key.mykmskey.id
  policy = jsonencode({
    Id = "example"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }

        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}


resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykmskey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id     = "log"
    status = "Enabled"

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    expiration {
      days = 90
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "tmp"
    status = "Enabled"

    filter {
      prefix = "tmp/"
    }

    expiration {
      date = "2023-01-13T00:00:00Z"
    }
  }
}


resource "aws_s3_bucket_logging" "bucket_logging" {
  bucket = aws_s3_bucket.bucket.id

  target_bucket = aws_s3_bucket.bucket.id
  target_prefix = "logs/"
}
