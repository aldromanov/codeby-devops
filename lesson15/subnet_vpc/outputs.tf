output "subnets_id" {
  value = { for s in data.yandex_vpc_subnet.all_subnets : s.zone => s.id }
}

output "subnets_info" {
  value = { for s in data.yandex_vpc_subnet.all_subnets : s.zone => s.v4_cidr_blocks[0] }
}
