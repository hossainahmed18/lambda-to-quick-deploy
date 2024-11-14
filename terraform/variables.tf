variable "lambda_runtime" {
  type    = string
  default = "nodejs20.x"
}
variable "region" {
  type    = string
  default = "eu-north-1"
}
variable "lambda_timeout" {
  type    = number
  default = 900
}
variable "lambda_architecture" {
  type    = string
  default = "x86_64"
}