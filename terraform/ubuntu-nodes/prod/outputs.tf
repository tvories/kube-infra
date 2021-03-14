resource "local_file" "ansible_inventory" {
  content = templatefile("ansible-inventory.tpl",{
    controlplane_ips = module.ubuntu_k8.controlplane_nodes[*].ip_address
    worker_ips = module.ubuntu_k8.worker_nodes[*].ip_address
    controlplane_nodes = module.ubuntu_k8.controlplane_nodes
    worker_nodes = module.ubuntu_k8.worker_nodes
    env = var.env
  })
  filename = "kube-inventory-${var.env}.yml"
}