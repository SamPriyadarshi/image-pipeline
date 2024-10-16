locals {
    packer_work_dir     = "/var/opt/packer"
    ansible_staging_dir = "${local.packer_work_dir}/provisioner-ansible-local/${uuidv4()}"
}
