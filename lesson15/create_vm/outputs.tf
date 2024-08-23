output "vm_ip" {
  value = yandex_compute_instance.vm_instance.network_interface[0].ip_address
}
