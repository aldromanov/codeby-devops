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

resource "yandex_compute_instance" "vm_instance" {
  name        = "vm-instance"
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80bca9kcrb3ubq7eaf"
    }
  }

  network_interface {
    subnet_id = lookup(var.subnets_ids, var.default_zone)
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }

  provisioner "file" {
    source      = var.ssh_private_key_path
    destination = "/home/ubuntu/id_rsa"
    connection {
      type        = "ssh"
      host        = self.network_interface[0].nat_ip_address
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }

  provisioner "file" {
    source      = var.ssh_public_key_path
    destination = "/home/ubuntu/id_rsa.pub"
    connection {
      type        = "ssh"
      host        = self.network_interface[0].nat_ip_address
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/id_rsa",
      "ssh-keyscan -H ${self.network_interface[0].nat_ip_address} >> ~/.ssh/known_hosts",
    ]
    connection {
      type        = "ssh"
      host        = self.network_interface[0].nat_ip_address
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }
}
