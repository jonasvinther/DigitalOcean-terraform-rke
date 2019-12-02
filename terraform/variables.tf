
variable "do_token" {}

variable "do_cluster_name" {}

variable "pvt_key" {}

variable "ssh_public_key_file" {
  default = "testkey.pub"
}

variable "ssh_private_key_file" {
  default = "testkey"
}

variable "master_count" {
  description = "The number of [etcd, controlplane] nodes to create"
  default = 1
}

variable "instance_count" {
  description = "The number of [worker] nodes to create. If instance_count is smaller than master_count, no worker nodes are created."
  default = 3
}
