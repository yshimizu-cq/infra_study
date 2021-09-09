// https://qiita.com/tsukakei/items/2751e245e38c814225f1

// terraform init後、バケット作成
//resource "aws_s3_bucket" "terraform_state" {
//  bucket = "${var.app_name}-tfstate-${var.environment}-test"
//  versioning {
//    enabled = true
//  }
//}

// バケット作成 -> terraform init -> terraform apply
//terraform {
//  backend "s3" {
//    bucket = "test-tfstate-prd-test"
//    key = "terraform.tfstate"
//    region = "ap-northeast-1"
//  }
//}
