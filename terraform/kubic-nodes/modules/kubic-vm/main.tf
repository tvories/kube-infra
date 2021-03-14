locals {
  controlplane_specs = [
    for i in range(var.controlplane_nodes) : {
      ip_address = "${var.ip_address_base}.${var.controlplane_ip_address_start + i}"
      name = "${var.controlplane_name_prefix}-${i + 1}"
      # type = i == 0 ? "init" : "controlplane"
      cpus = var.controlplane_cpu
      memory = var.controlplane_memory
      disk_size = var.controlplane_disk_size
      ignition_data = base64encode(templatefile("${path.module}/ignition.tpl", {
        hostname = "${var.controlplane_name_prefix}-${i + 1}"
        dns_domain = var.dns_domain
        gateway = var.network_gateway
        netmask = var.network_netmask
        nameservers = var.nameservers
        ip_address = "${var.ip_address_base}.${var.controlplane_ip_address_start + i}"
      }))
    }
  ]
  worker_specs = [
    for i in range(var.worker_nodes) : {
      ip_address = "${var.ip_address_base}.${var.worker_ip_address_start + i}"
      name = "${var.worker_name_prefix}-${i + 1}"
      cpus = var.worker_cpu
      memory = var.worker_memory
      disk_size = var.worker_disk_size
      ignition_data = base64encode(templatefile("${path.module}/ignition.tpl", {
        hostname = "${var.worker_name_prefix}-${i + 1}"
        dns_domain = var.dns_domain
        gateway = var.network_gateway
        netmask = var.network_netmask
        nameservers = var.nameservers
        ip_address = "${var.ip_address_base}.${var.worker_ip_address_start + i}"
      }))
    }
  ]
}

# ----------------------------------------------------------------------------
#   vSphere resources
# ----------------------------------------------------------------------------
data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}
data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_resource_pool" "resource_pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_tag_category" "ansible" {
  name = "ansible"
}
data "vsphere_tag" "kubic" {
  name = "kubic"
  category_id = data.vsphere_tag_category.ansible.id
}
data "vsphere_tag" "kubic_worker" {
  name = "kubic_worker"
  category_id = data.vsphere_tag_category.ansible.id
}
data "vsphere_tag" "kubic_master" {
  name = "kubic_master"
  category_id = data.vsphere_tag_category.ansible.id
}

resource "vsphere_virtual_machine" "controlplane" {
  count = length(local.controlplane_specs)
  name = local.controlplane_specs[count.index].name
  resource_pool_id           = data.vsphere_resource_pool.resource_pool.id
  host_system_id             = data.vsphere_host.host.id
  datastore_id               = data.vsphere_datastore.datastore.id
  # datacenter_id              = data.vsphere_datacenter.datacenter.id
  wait_for_guest_net_timeout = -1
  tags = [data.vsphere_tag.kubic.id, data.vsphere_tag.kubic_master.id]

  num_cpus = local.controlplane_specs[count.index].cpus
  memory   = local.controlplane_specs[count.index].memory

  guest_id = data.vsphere_virtual_machine.template.guest_id
  
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  
  # Disk
  disk {
    label = "disk0.vmdk"
    size = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = true
    # size = local.controlplane_specs[count.index].disk_size
  }

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = var.vsphere_nic_type
  }

  # for vsphere-kubernetes integration
  enable_disk_uuid = "true"
  firmware = "efi"

  # sets the talos configuration
  extra_config = {
    "guestinfo.ignition.config.data" = local.controlplane_specs[count.index].ignition_data
    "guestinfo.ignition.config.data.encoding" = "base64"
  }
 
  lifecycle {
    ignore_changes = [
      disk[0].io_share_count,
      disk[0].thin_provisioned,
      clone,
    ]
  }
}
resource "vsphere_virtual_machine" "worker" {
  count = length(local.worker_specs)
  name = local.worker_specs[count.index].name
  resource_pool_id           = data.vsphere_resource_pool.resource_pool.id
  host_system_id             = data.vsphere_host.host.id
  datastore_id               = data.vsphere_datastore.datastore.id
  wait_for_guest_net_timeout = -1
  tags = [data.vsphere_tag.kubic.id, data.vsphere_tag.kubic_worker.id]

  num_cpus = local.worker_specs[count.index].cpus
  memory   = local.worker_specs[count.index].memory

  guest_id = data.vsphere_virtual_machine.template.guest_id
  
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  
  # Disk
  disk {
    label = "disk0.vmdk"
    size = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = true
  }

  # Disk 2
  disk {
    label = "disk1.vmdk"
    size = var.worker_data_disk_size
    thin_provisioned = true
    unit_number = 1
  }

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = var.vsphere_nic_type
  }

  # for vsphere-kubernetes integration
  enable_disk_uuid = "true"
  firmware = "efi"

  # sets the talos configuration
  extra_config = {
    "guestinfo.ignition.config.data" = local.worker_specs[count.index].ignition_data
    "guestinfo.ignition.config.data.encoding" = "base64"
  }
 
  lifecycle {
    ignore_changes = [
      disk[0].io_share_count,
      disk[0].thin_provisioned,
      disk[1].thin_provisioned,
      disk[1].io_share_count,
      clone,
    ]
  }
}