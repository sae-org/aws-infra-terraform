# creating s3 bucket
resource "aws_s3_bucket" "s3" {
  bucket = "dev-sae-tf-backend"

  tags = {
    Name = "dev-sae-tf-backend"
  }
}


# s3 bucket ownership controls 
resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.s3.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


# create kms keys for encryption on bucket objects 
resource "aws_kms_key" "kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


# s3 server side encryption 
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_sse" {
  bucket = aws_s3_bucket.s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


# s3 policy 
resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.s3.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Statement2",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::886687538523:user/Saeeda",
              "arn:aws:iam::886687538523:user/terraform"
            ]
          },
          "Action" : "s3:*",
          "Resource" : [
            "arn:aws:s3:::dev-sae-tf-backend",
            "arn:aws:s3:::dev-sae-tf-backend/*"
          ]
        }
      ]
    }
  )
}




