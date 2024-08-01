# AWS s3 Backend with Terraform (SNS, KMS & Lifecyle)

This repository contains Terraform configurations for setting up an AWS infrastructure with S3, SNS, and KMS. The configuration includes creating an S3 bucket, setting up notifications, encryption, lifecycle management, and creating SNS topics and subscriptions.

## Files Overview 

### `datasource.tf`

Defines data sources used in the Terraform configuration:
- **AWS IAM Policy Document**: Grants SNS permission to publish to the S3 bucket.
- **AWS Caller Identity**: Retrieves the current AWS account details.
- **AWS Region**: Retrieves the current AWS region.
- **Outputs**: Outputs the AWS region and account ID.

### `s3.tf`

Contains resources related to S3, SNS, and KMS:
- **S3 Bucket**: Creates an S3 bucket with a unique name and tags.
- **Random Pet**: Generates a random string for the bucket name.
- **Random Integer**: Generates a random integer for the bucket name.
- **SNS Topic**: Creates an SNS topic with the specified policy.
- **S3 Bucket Notification**: Sets up a notification for S3 bucket events to trigger the SNS topic.
- **SNS Topic Subscription**: Subscribes an email endpoint to the SNS topic.
- **S3 Bucket Versioning**: Enables versioning for the S3 bucket.
- **KMS Key**: Creates a KMS key for encryption.
- **KMS Key Policy**: Sets a policy for the KMS key.
- **S3 Bucket Server-Side Encryption**: Configures server-side encryption for the S3 bucket using the KMS key.
- **S3 Bucket Lifecycle Configuration**: Sets lifecycle rules for the S3 bucket.
- **S3 Bucket Logging**: Enables logging for the S3 bucket.

### `variables.tf`

Defines input variables used in the configuration:
- `topic_name`: Name of the SNS topic.
- `team`: Team name for bucket naming.
- `my_bucket`: Name of the S3 bucket.
- `env`: Environment (e.g., prod, dev).
- `status`: Status for versioning configuration.

### `providers.tf`

Specifies the required Terraform version and providers:
- **Terraform Version**: `~> 1.0`
- **AWS Provider**: `~> 5.0`
- **AWS Region**: `us-west-2`

