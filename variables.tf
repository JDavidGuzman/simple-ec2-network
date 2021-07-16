variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type = string
}

variable "repo" {
  type = string
}

variable "user_ip" {
  type      = string
  sensitive = true
}

variable "key_file" {
  type      = string
  sensitive = true
}

variable "key_file_private" {
  type      = string
  sensitive = true
}

variable "ssh_user" {
  type      = string
  sensitive = true
}

variable "num_instances" {
  type = number
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}