data "template_file" "startup_script" {
  template = <<EOF
apt-get update -y
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

adduser ubuntu --disabled-password --gecos ""
usermod -aG docker ubuntu
EOF
}

resource "digitalocean_droplet" "rke-node" {
  image    = "ubuntu-18-04-x64"
  name     = "rke-nodes-${count.index}"
  region   = "fra1"
  # size     = "s-1vcpu-1gb"
  size       = "s-2vcpu-2gb"
  ssh_keys = ["47:a6:8a:c5:29:7d:d3:0a:67:e1:40:02:fd:4f:ce:c2", "${digitalocean_ssh_key.default.fingerprint}"]
  count    = "${var.instance_count}"

  private_networking = true

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file(var.ssh_private_key_file)}"
      host        = self.ipv4_address
      #host        = "${element(digitalocean_droplet.rke-node.*.ipv4_address, count.index)}"
    }
    inline = [
      "${data.template_file.startup_script.rendered}"
    ]
  }
}

output "instance_ips" {
  value = ["${digitalocean_droplet.rke-node.*.ipv4_address}"]
}
