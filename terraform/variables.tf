variable "app_name" {
  description = "アプリ名"
  type        = string

  default = "test"
}

variable "environment" {
  description = "環境"
  type        = string

  default = "prd"
}
