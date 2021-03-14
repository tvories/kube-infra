variable "endpoint_dns" {
  description = "The dns 'load balancer' for kubic nodes"
  type = string
  default = "kube-prod"
}
variable "dns_domain" {
  type = string
  default = "mcbadass.local"
}
variable "vsphere_user" { }
variable "vsphere_password" { }
variable "vsphere_server" { }
variable "vsphere_datacenter" {
  description = "In which datacenter the VM will be deployed"
  type        = string
  default     = ""

  validation {
    condition     = var.vsphere_datacenter != ""
    error_message = "You must specify the destination datacenter for the talos virtual machines."
  }
}
variable "vsphere_resource_pool" {
  description = "VM Resource Pool"
  type        = string
  default = ""

  validation {
    condition     = var.vsphere_resource_pool != ""
    error_message = "You must specify the destination resource pool."
  }
}
variable "vsphere_host" {
  description = "The host to deploy to"
  type        = string
  default = ""

  validation {
    condition     = var.vsphere_host != ""
    error_message = "You must specify the destination esxi host.  Hopefully this requirement will be removed in a future release."
  }
}
variable "vsphere_cluster" {
  description = "In which cluster the VM will be deployed"
  type        = string
  default = ""

  validation {
    condition     = var.vsphere_cluster != ""
    error_message = "You must specify the destination cluster."
  }
}
variable "vsphere_datastore" {
  description = "What is the name of the destination VM datastore"
  type        = string
  default = ""

  validation {
    condition     = var.vsphere_datastore != ""
    error_message = "You must specify the destination datastore."
  }
}
variable "vsphere_network" {
  description = "What is the name of the VM Network?"
  type        = string
  default = ""

  validation {
    condition     = var.vsphere_network != ""
    error_message = "You must specify the destination network."
  }
}
variable "vsphere_nic_type" {
  description = "NIC type (vmxnet3 or e1000)"
  type        = string
  default     = "vmxnet3"

  validation {
    condition     = var.vsphere_nic_type != "vmxnet3" || var.vsphere_nic_type != "e1000"
    error_message = "Number of control plane nodes must be either one, or three (HA cluster)."
  }
}

variable "ubuntu_ova_url" {
  description = "URL for ubuntu cloud ova"
  type = string
  default = "https://cloud-images.ubuntu.com/releases/groovy/release-20210224/ubuntu-20.10-server-cloudimg-amd64.ova"
  
  validation {
    condition = var.ubuntu_ova_url != ""
    error_message = "You must provide an OVA url."
  }
}
variable "controlplane_nodes" {
  description = "Number of control plane nodes"
  type        = number
  default     = 1

  validation {
    condition     = var.controlplane_nodes != 1 || var.controlplane_nodes != 3
    error_message = "Number of control plane nodes must be either one, or three (HA cluster)."
  }
}
variable "ip_address_base" {
  description = "The base network/subnet IE: 192.168.1"
  type        = string

  validation {
    condition = var.ip_address_base != ""
    error_message = "Must provide base network."
  }
}
variable "controlplane_ip_address_start" {
  description = "Don't overlap with worker_ip_address_start! The first control plane address IE: 100"
  type        = string
  default     = ""

  validation {
    condition = var.controlplane_ip_address_start != ""
    error_message = "You must provide a starting IP address for the controlplane nodes."
  }
}
variable "controlplane_name_prefix" {
  description = "Name prefix for control plane servers (IE k8-cp)"
  type        = string
  default     = "kubic-k8-cp"
}
variable "controlplane_cpu" {
  description = "Number of CPU for Controlplane systems"
  type        = number
  default     = 2
}
variable "controlplane_memory" {
  description = "Memory in MB for Controlplane systems"
  type        = number
  default     = 2048
}
variable "ova_disk_name" {
  description = "The name of the OVA disk"
  type        = string
  default     = "ubuntu-groovy-20.10-cloudimg.vmdk"
}
variable "controlplane_disk_size" {
  description = "Size in GB of the control plane disk"
  type        = number
  default     = 15
}
variable "meta_data_nic" {
  description = "The name of the NIC to configure in the meta-data template."
  type = string
  default = "ens192"
}
variable "local_ovf_path" {
  description = "The datastore path to the local ovf file."
  type = string
  default = ""

  # validation {
  #   condition = var.local_ovf_path != ""
  #   error_message = "You must provide a location for the local ovf path."
  # }
}
variable "template_name" {
  description = "The name of the template to deploy from"
  type = string
  default = ""
}
variable "network_gateway" {
  description = "The network default gateway."
  type = string
  default = ""

  validation {
    condition = var.network_gateway != ""
    error_message = "You must provide a network gateway."
  }
}
variable "network_netmask" {
  description = "The network default gateway."
  type = string
  default = "255.255.255.0"

  validation {
    condition = var.network_netmask != ""
    error_message = "You must provide a network netmask IE: 255.255.255.0."
  }
}
variable "nameservers" {
  description = "A list of DNS nameservers."
  type = list(string)
  default = []

  validation {
    condition = var.nameservers != []
    error_message = "You must provide DNS nameservers IE: [192.168.1.240]."
  }
}
variable "worker_ip_address_start" {
  description = "Don't overlap with worker_ip_address_start! The first control plane address IE: 100"
  type        = string
  default     = ""

  validation {
    condition = var.worker_ip_address_start != ""
    error_message = "You must provide a starting IP address for the controlplane nodes."
  }
}
variable "worker_name_prefix" {
  description = "Name prefix for control plane servers (IE k8-cp)"
  type        = string
  default     = "kubic-k8-worker"
}
variable "worker_cpu" {
  description = "Number of CPU for Controlplane systems"
  type        = number
  default     = 2
}
variable "worker_memory" {
  description = "Memory in MB for Controlplane systems"
  type        = number
  default     = 2048
}
variable "worker_disk_size" {
  description = "Worker OS disk size"
  type = number
  default = 24
}
variable "worker_data_disk_size" {
  description = "Size for the worker data disk"
  type = number
  default = 1
}
variable "worker_nodes" {
  description = "Number of worker plane nodes"
  type        = number
  default     = 1
}
variable "tag_ubuntu_k8_env" {}
variable "dns_server" {}
variable "env" {
  description = "Prod or staging."
  type = string
}