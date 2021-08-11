variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc_id" {
  type    = string
  default = "vpc-xxxxxxxx"
}

variable "function_name" {
  type    = string
  default = "jobs_alert"
}

variable "slack_hook_url" {
  type    = string
  default = "https://hooks.slack.example.com/services/xxxxxxxx"
}
