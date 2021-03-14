---

all:
  hosts:
  children:
    controlplane_${env}:
      hosts:
%{for index, ip in controlplane_ips ~}
        ${controlplane_nodes[index].name}:
          ansible_host: ${ip}
%{endfor ~}
    worker_${env}:
      hosts:
%{for index, ip in worker_ips ~}
        ${worker_nodes[index].name}:
          ansible_host: ${ip}
%{endfor ~}
    kubernetes_cluster_${env}:
      hosts:
%{for index, ip in controlplane_ips ~}
        ${controlplane_nodes[index].name}:
          ansible_host: ${ip}
%{endfor ~}
%{for index, ip in worker_ips ~}
        ${worker_nodes[index].name}:
          ansible_host: ${ip}
%{endfor ~}
