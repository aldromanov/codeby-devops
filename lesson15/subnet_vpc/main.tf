terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.70"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = var.key_file
  cloud_id                 = var.yandex_cloud_id
  folder_id                = var.yandex_folder_id
}


data "yandex_vpc_network" "my_vpc" {
  network_id = var.vpc_id
}

data "yandex_vpc_subnet" "all_subnets" {
  subnet_id = each.key
  for_each  = toset(data.yandex_vpc_network.my_vpc.subnet_ids)
}
