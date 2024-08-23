module "subnet_vpc" {
  source           = "./subnet_vpc"
  yandex_cloud_id  = var.yandex_cloud_id
  yandex_folder_id = var.yandex_folder_id
  key_file         = var.key_file
  vpc_id           = var.vpc_id
}

module "create_vm" {
  source               = "./create_vm"
  subnets_ids          = module.subnet_vpc.subnets_id
  yandex_cloud_id      = var.yandex_cloud_id
  yandex_folder_id     = var.yandex_folder_id
  key_file             = var.key_file
  default_zone         = var.default_zone
  ssh_private_key_path = var.ssh_private_key_path
  ssh_public_key_path  = var.ssh_public_key_path
}

