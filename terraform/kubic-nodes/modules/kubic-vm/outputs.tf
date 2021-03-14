output "controlplane_nodes" {
  description = "The Controlplane Spec objects"
  value = local.controlplane_specs
}
output "worker_nodes" {
  description = "The worker Spec objects"
  value = local.worker_specs
}