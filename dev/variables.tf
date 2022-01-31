variable "region" {
  description = "This is the cloud hosting region where your webapp will be deployed."
  type = string
  default = "eu-central-1"
}

variable "env_prefix" {
  description = "This is the environment where your webapp is deployed. qa, prod, or dev"
  type = string
  default = "dev"
}