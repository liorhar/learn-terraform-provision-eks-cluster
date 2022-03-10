variable "region" {
  description = "This is the cloud hosting region where your webapp will be deployed."
  type        = string
  default     = "us-east-2"
}

variable "env_prefix" {
  description = "This is the environment where your webapp is deployed. qa, prod, or dev"
  type        = string
  default     = "prod"
}

variable "vpc_id" {
  type    = string
  default = "vpc-05d7b65e7c7162bae"
}

variable "prod_eks_sg" {
  type    = string
  default = "sg-0d8fac794a4f367c8"
}

variable "prod_zone_id" {
  type        = string
  description = "Hosted zone id"
  default     = "Z09148917A6FB810L644"
}
