provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

provider "dns" {
  update {
    server = var.dns_server # Using the hostname is important in order for an SPN to match
  }
}

module "kubic_k8" {
    source                        = "./modules/kubic-vm/"
    controlplane_nodes            = var.controlplane_nodes
    controlplane_cpu              = var.controlplane_cpu
    controlplane_memory           = var.controlplane_memory
    controlplane_disk_size        = var.controlplane_disk_size
    worker_nodes                  = var.worker_nodes
    worker_cpu                    = var.worker_cpu
    worker_memory                 = var.worker_memory
    worker_disk_size              = var.worker_disk_size
    worker_data_disk_size         = var.worker_data_disk_size
    vsphere_datacenter            = var.vsphere_datacenter
    vsphere_resource_pool         = var.vsphere_resource_pool
    vsphere_datastore             = var.vsphere_datastore
    vsphere_host                  = var.vsphere_host
    vsphere_cluster               = var.vsphere_cluster
    vsphere_network               = var.vsphere_network
    dns_domain                    = var.dns_domain
    ip_address_base               = var.ip_address_base
    controlplane_ip_address_start = var.controlplane_ip_address_start
    worker_ip_address_start       = var.worker_ip_address_start
    template_name                 = var.template_name
    nameservers                   = var.nameservers
    network_gateway               = var.network_gateway
    network_netmask               = var.network_netmask
}

resource "dns_a_record_set" "endpoint" {
  zone = "${var.dns_domain}."
  name = var.endpoint_dns
  addresses = tolist(module.kubic_k8.controlplane_nodes[*].ip_address)
  ttl = 0
}

resource "dns_a_record_set" "controlplane_dns" {
  count = length(module.kubic_k8.controlplane_nodes)
  zone = "${var.dns_domain}."
  name = module.kubic_k8.controlplane_nodes[count.index].name
  addresses = [module.kubic_k8.controlplane_nodes[count.index].ip_address]
}
resource "dns_a_record_set" "worker_dns" {
  count = length(module.kubic_k8.worker_nodes)
  zone = "${var.dns_domain}."
  name = module.kubic_k8.worker_nodes[count.index].name
  addresses = [module.kubic_k8.worker_nodes[count.index].ip_address]
}
