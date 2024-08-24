output "info_subnets" {
  value = module.subnet_vpc.subnets_info
}

output "info_zone_selected" {
  value = var.default_zone
}

output "vm_ip" {
  value = module.create_vm.vm_ip
}

