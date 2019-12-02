data "template_file" "head_cluster_yml" {
  template = <<EOF
cluster_name: mycluster
# These work with rke v0.2.4 - see https://github.com/rancher/rke/releases
kubernetes_version: v1.14.1-rancher1-2
network:
  plugin: flannel
nodes:
EOF
}

data "template_file" "cluster_yml" {
  template = <<EOF
  - address: $${ip}
    internal_address: $${iip}
    user: root
    role: $${roles}
    ssh_key_path: testkey
EOF

  count = "${var.instance_count}"
  vars = {
    name = "cluster-inst-${count.index}"
    # name = "${var.global_prefix}inst-${count.index}"
    ip = "${digitalocean_droplet.rke-node.*.ipv4_address[count.index]}"
    iip = "${digitalocean_droplet.rke-node.*.ipv4_address_private[count.index]}" 
    # "${google_compute_instance.compute-inst.*.network_interface.0.network_ip[count.index]}"
    roles = "${ count.index<var.master_count ? "[controlplane,etcd]" : "[worker]"}"
  }
}

resource "null_resource" "cluster_yml" {
  triggers = {
    template_rendered = "${join("\n", data.template_file.cluster_yml.*.rendered)}"
  }
  provisioner "local-exec" {
    command = "echo '${join("", concat(data.template_file.head_cluster_yml.*.rendered, data.template_file.cluster_yml.*.rendered))}' > cluster.yml"
  }
}