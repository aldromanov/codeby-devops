variable "yandex_cloud_id" {
  type = string
}

variable "yandex_folder_id" {
  type = string
}

variable "key_file" {
  type = string
}

variable "default_zone" {
  type = string
}

variable "subnets_ids" {
  type = map(string)
}

variable "ssh_public_key_path" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
}

