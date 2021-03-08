# ubuntu-k8 assumes you have already imported the cloud image for ubuntu 20.04
# https://cloud-images.ubuntu.com/
source "vsphere-clone" "ubuntu-k8" {
  vcenter_server = var.vsphere_server
  username = var.vsphere_username
  password = var.vsphere_password
  insecure_connection = var.vsphere_insecure_cert
  cluster = var.vsphere_cluster
  datacenter = var.vsphere_datacenter
  host = var.vsphere_host
  datastore = var.vsphere_datastore
  convert_to_template = true
  folder = var.vsphere_folder

  ip_wait_timeout = "120m"
  communicator = "ssh"
  ssh_username = var.connection_username
  ssh_password = var.connection_password
  # ssh_timeout = "1hr"
  ssh_port = "22"
  ssh_handshake_attempts = "100"
  shutdown_timeout = "15m"
  vm_name = "ubuntu-k8-packer"
  template = "ubuntu-focal-20.04-cloudimg"
  # the vapp properties allow us to set a username and password on first boot
  vapp {
     properties = {
        hostname  = "ubuntu-k8-packer"
        user-data = base64encode(file("./boot_config/ubuntu-20.04/user-data"))
     }
   }
}

# This assumes you have imported the latest kubic built as a template in vsphere
# https://en.opensuse.org/Portal:Kubic/Downloads
source "vsphere-clone" "kubic" {
  vcenter_server = var.vsphere_server
  username = var.vsphere_username
  password = var.vsphere_password
  insecure_connection = var.vsphere_insecure_cert
  cluster = var.vsphere_cluster
  datacenter = var.vsphere_datacenter
  host = var.vsphere_host
  datastore = var.vsphere_datastore
  convert_to_template = true
  folder = var.vsphere_folder

  ip_wait_timeout = "120m"
  communicator = "ssh"
  ssh_username = var.connection_username
  ssh_password = var.connection_password
  # ssh_timeout = "1hr"
  ssh_port = "22"
  ssh_handshake_attempts = "100"
  shutdown_timeout = "15m"
  vm_name = "kubic-packer"
  template = "kubic-import"
  configuration_parameters = {
    "guestinfo.ignition.config.data" = base64encode(file("./kubic_ignition.json"))
    "guestinfo.ignition.config.data.encoding" = "base64"
  }
}

build {
  sources = [
    "source.vsphere-clone.ubuntu-k8"
  ]
  provisioner "ansible" {
    playbook_file = "./pb-ubuntu-k8.yaml"
    user = var.connection_username
    extra_arguments = ["--extra-vars", "ansible_ssh_pass=${var.connection_password} ansible_user_key='${var.ansible_user_key}' ansible_username=${var.ansible_username}"]
  }
  provisioner "shell" {
      execute_command = "echo '${var.connection_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
      scripts = [
          "scripts/cleanup.sh",
          # "scripts/ubuntu-prep.sh",
          "scripts/clean-ssh-hostkeys.sh"
      ]
    }
}

build {
  sources = [
    "source.vsphere-clone.kubic"
  ]
  provisioner "shell" {
    inline = ["sudo mkdir -p /home/${var.connection_username} && sudo chown ${var.connection_username} /home/${var.connection_username}"]
  }
  provisioner "ansible" {
    playbook_file = "./kubic-ansible.yaml"
    user = var.connection_username
    extra_arguments = ["--extra-vars", "ansible_ssh_pass=${var.connection_password}", "-vvv"]
  }
}