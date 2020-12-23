variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "aws_key_name" {
  type = string
}

variable "web_server_instance_type" {
  type = string
}

variable "compute_server_instance_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "dmz_subnet" {
  type = string
}

variable "compute_subnet" {
  type = string
}

variable "web_server_count" {
  description = "The number of web servers to deploy"
  type = number
}