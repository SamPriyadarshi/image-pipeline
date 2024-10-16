packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/googlecompute"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">=1.0.4"
    }
  }

}

variable "zone" {
  default = "us-central1-f"
}

variable "project_id" {
  type = string
  default = "symbotic-dev-433806"
}

variable "source_image" {
  type = string
  default = "rocky-linux-9"
}

variable "service_account" {
  type = string
  default = "jenkin@symbotic-dev-433806.iam.gserviceaccount.com"
}

source "googlecompute" "rocky-linux-9" {
  image_name              = "rocky-linux-{{timestamp}}"
  machine_type            = "n1-standard-1"
  source_image_family     = var.source_image
  ssh_username            = "packer"
  use_os_login            = true
  zone                    = var.zone
  project_id              = var.project_id
  service_account_email   = var.service_account
}

build {
  sources = ["source.googlecompute.rocky-linux-9"]

  provisioner "ansible" {
    ansible_env_vars        = ["PACKER_ANSIBLE_TEST=1", "ANSIBLE_HOST_KEY_CHECKING=False"]
    empty_groups            = ["PACKER_EMPTY_GROUP"]
    extra_arguments         = ["--private-key", "ansible-test-id"]
    groups                  = ["PACKER_TEST"]
    playbook_file           = "./ansible/playbook.yaml"
  }
}
