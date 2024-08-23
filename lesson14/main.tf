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

resource "yandex_vpc_network" "my_net" {
  name = "network"
}

resource "yandex_vpc_subnet" "my_public_subnet" {
  name           = "public-net"
  network_id     = yandex_vpc_network.my_net.id
  v4_cidr_blocks = ["10.128.100.0/24"]
  zone           = var.default_zone
}

resource "yandex_vpc_subnet" "my_private_subnet" {
  name           = "private-net"
  network_id     = yandex_vpc_network.my_net.id
  v4_cidr_blocks = ["10.128.101.0/24"]
  zone           = var.default_zone
  route_table_id = yandex_vpc_route_table.my_route_table.id
}

resource "yandex_vpc_gateway" "my_nat_gateway" {
  name      = "nat-gateway"
  folder_id = var.yandex_folder_id
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "my_route_table" {
  name       = "route-table"
  network_id = yandex_vpc_network.my_net.id
  folder_id  = var.yandex_folder_id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.my_nat_gateway.id
  }
}

resource "yandex_compute_instance" "public" {
  name        = "public"
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
    subnet_id = yandex_vpc_subnet.my_public_subnet.id
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
      "ssh-keyscan -H ${yandex_compute_instance.private.network_interface.0.ip_address} >> ~/.ssh/known_hosts",
    ]
    connection {
      type        = "ssh"
      host        = self.network_interface[0].nat_ip_address
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
  }
}

resource "yandex_compute_instance" "private" {
  name        = "private"
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
    subnet_id = yandex_vpc_subnet.my_private_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

resource "null_resource" "configure_private" {
  depends_on = [yandex_compute_instance.public, yandex_compute_instance.private]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "echo 'server { listen 8080 default_server; listen [::]:8080 default_server; location / { root /var/www/html; index index.html; } }' | sudo tee /etc/nginx/sites-available/default",
      "sudo systemctl restart nginx",
      "sudo ufw allow 8080",
      "sudo ufw allow ssh",
      "sudo ufw --force enable"
    ]
    connection {
      type                = "ssh"
      host                = yandex_compute_instance.private.network_interface[0].ip_address
      user                = "ubuntu"
      private_key         = file(var.ssh_private_key_path)
      bastion_host        = yandex_compute_instance.public.network_interface[0].nat_ip_address
      bastion_user        = "ubuntu"
      bastion_private_key = file(var.ssh_private_key_path)
    }
  }
}

resource "yandex_vpc_security_group" "public_sg" {
  name       = "public-sg"
  network_id = yandex_vpc_network.my_net.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private_sg" {
  name       = "private-sg"
  network_id = yandex_vpc_network.my_net.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.128.101.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = ["10.128.101.0/24"]
  }
}

output "private_instance_ip" {
  value = yandex_compute_instance.private.network_interface[0].ip_address
}


resource "yandex_compute_instance" "imported_instance" {
  name        = "compute-vm"
  platform_id = "standard-v1"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80jdh4pvsj48qftb3d"
    }
  }
  network_interface {
    subnet_id = "default"
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}
