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
  default = "mando-host-project"
}

variable "source_image" {
  type = string
  default = "rocky-linux-9"
}

variable "service_account" {
  type = string
  default = "liquibase-sa@symbotic-dev-433806.iam.gserviceaccount.com"
}

source "googlecompute" "rocky-linux-9" {
  image_name              = "rocky-linux-{{timestamp}}"
  machine_type            = "n1-standard-1"
  source_image_family     = var.source_image
  ssh_username            = "packer"
  ssh_password            = "packer"
  use_os_login            = true
  zone                    = var.zone
  project_id              = var.project_id
  # service_account_email   = var.service_account
  # metadata = {
  #     enable-guest-attributes = "TRUE",
  #     enable-osconfig = "TRUE",
  #     enable-oslogin = "FALSE",
  #   }
}

build {
  sources = ["source.googlecompute.rocky-linux-9"]

  provisioner "shell" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install epel-release -y",
      "sudo dnf install ansible -y",
    ]
  }

  provisioner "ansible-local" {
    playbook_file           = "./ansible/playbook.yaml"
  }
}
