variable "dns_username" {
  type = string
  default = "packer"
}
variable "dns_password" {
  type = string
  default = ""
}
variable "endpoint_dns" {
  description = "The dns 'load balancer' for kubic nodes"
  type = string
  default = "kubic"
}
variable "vsphere_user" { }
variable "vsphere_password" { }
variable "vsphere_server" { }
variable "vsphere_datacenter" {}
variable "vsphere_resource_pool" {}
variable "vsphere_datastore" {}
variable "vsphere_host" {}
variable "vsphere_cluster" {}
variable "vsphere_network" {}
variable "dns_server" {}
variable "controlplane_nodes" {}
variable "controlplane_cpu" {}
variable "controlplane_memory" {}
variable "controlplane_disk_size" {}
variable "worker_nodes" {}
variable "worker_cpu" {}
variable "worker_memory" {}
variable "worker_disk_size" {}
variable "worker_data_disk_size" {}
variable "dns_domain" {}
variable "ip_address_base" {}
variable "controlplane_ip_address_start" {}
variable "worker_ip_address_start" {}
variable "template_name" {}
variable "nameservers" {
  type = list(string)
}
variable "network_gateway" {}
variable "network_netmask" {}