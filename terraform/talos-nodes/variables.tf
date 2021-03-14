variable "vsphere_user" { }
variable "vsphere_password" { }
variable "vsphere_server" { }
variable "talos_version" {
  default = "v0.8.4"
}
variable "controlplane_nodes" {
  type = number
}
variable "controlplane_cpu" {
  type = number
}
variable "controlplane_disk_size" {}
variable "worker_nodes" {}
variable "worker_cpu" {}
variable "worker_memory" {}
variable "worker_disk_size" {}
variable "vsphere_datacenter" {}
variable "vsphere_resource_pool" {}
variable "vsphere_datastore" {}
variable "vsphere_host" {}
variable "vsphere_cluster" {}
variable "vsphere_network" {}
variable "talos_cluster_endpoint" {}
variable "nameservers" {
  type = list(string)
}
variable "dns_domain" {}
variable "ip_netmask" {}
variable "ip_gateway" {}
variable "ip_address_base" {}
variable "controlplane_ip_address_start" {}
variable "worker_ip_address_start" {}
variable "talos_crt" {}
variable "talos_key" {}
variable "kube_crt" {}
variable "kube_key" {}
variable "etcd_crt" {}
variable "etcd_key" {}
variable "admin_crt" {}
variable "admin_key" {}
variable "talos_token" {}
variable "kube_token" {}
variable "kube_enc_key" {}