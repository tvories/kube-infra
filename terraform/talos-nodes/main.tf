provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

module "talos" {
  source  = "tvories/talos/vsphere"
  talos_version = var.talos_version
  controlplane_nodes = var.controlplane_nodes
  controlplane_cpu = var.controlplane_cpu
  controlplane_disk_size = var.controlplane_disk_size
  worker_nodes = var.worker_nodes
  worker_cpu = var.worker_cpu
  worker_memory = var.worker_memory
  worker_disk_size = var.worker_disk_size
  add_extra_node_disk = false
  vsphere_nic_type = "vmxnet3"
  vsphere_datacenter = var.vsphere_datacenter
  vsphere_resource_pool  = var.vsphere_resource_pool
  vsphere_datastore      = var.vsphere_datastore
  vsphere_host           = var.vsphere_host
  vsphere_cluster        = var.vsphere_cluster
  vsphere_network        = var.vsphere_network
  talos_config_path      = "./"
  talos_cluster_endpoint = var.talos_cluster_endpoint
  ip_gateway       = "192.168.80.1"
  ip_netmask       = "/24"
  nameservers      = var.nameservers
  dns_domain                    = var.dns_domain
  ip_address_base               = var.ip_address_base
  controlplane_ip_address_start = var.controlplane_ip_address_start
  worker_ip_address_start       = var.worker_ip_address_start

  # Custom calico CNI
  custom_cni        = true
  cni_urls = ["https://docs.projectcalico.org/manifests/calico.yaml"]

  talos_crt = var.talos_crt
  talos_key = var.talos_key
  kube_crt = var.kube_crt
  kube_key = var.kube_key
  etcd_crt = var.etcd_crt
  etcd_key = var.etcd_key
  admin_crt = var.admin_crt
  admin_key = var.admin_key
  talos_token = var.talos_token
  kube_token = var.kube_token
  kube_enc_key = var.kube_enc_key
}
