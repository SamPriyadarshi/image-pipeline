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
  default = "jenkins@mando-host-project.iam.gserviceaccount.com"
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
  scopes                  = [
      "https://www.googleapis.com/auth/cloud-platform"
  ]
}

build {
  sources = ["source.googlecompute.rocky-linux-9"]

  provisioner "shell" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install epel-release -y",
      "sudo dnf install ansible -y",
      "sudo install -d -o ${build.User} ${local.packer_work_dir} ${local.ansible_staging_dir}",
      "gcloud config set project mando-host-project",
      "gcloud secrets versions access 1  --secret=sam-cert --out-file=/etc/pki/ca-trust/source/anchors/sam.corp_CA.cer",
      "update-ca-trust",
      "systemctl disable firewalld",
    ]
  }

  provisioner "ansible-local" {
    playbook_dir            = "./ansible"
    playbook_file           = "./ansible/playbook.yaml"
    staging_directory       = local.ansible_staging_dir
  }
}
