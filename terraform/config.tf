# Upload SSH key to DigitalOcean
# RKE needs this for communicating with DigitalOcean droplets
resource "digitalocean_ssh_key" "default" {
  name       = "Terraform test key"
  public_key = "${file(var.ssh_public_key_file)}"
}

# Get a Digital Ocean token from your Digital Ocean account
#   See: https://www.digitalocean.com/docs/api/create-personal-access-token/
# Set TF_VAR_do_token to use your Digital Ocean token automatically
provider "digitalocean" {
  token = "${var.do_token}"
}

resource "tls_private_key" "node-key" {
  algorithm = "RSA"
}