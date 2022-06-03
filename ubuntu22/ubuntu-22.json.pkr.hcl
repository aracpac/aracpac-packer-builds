# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "virtualbox-iso" "main" {
  boot_command            = [ " <wait>", " <wait>", " <wait>", " <wait>", " <wait>", "c", "<wait>", "set gfxpayload=keep", "<enter><wait>", "linux /casper/vmlinuz quiet <wait>", " autoinstall<wait>", " ds=nocloud-net<wait>", "\\;s=http://<wait>", "{{.HTTPIP}}<wait>", ":{{.HTTPPort}}/<wait>", " ---", "<enter><wait>", "initrd /casper/initrd<wait>", "<enter><wait>", "boot<enter><wait>" ]
  boot_wait               = "5s"
  cpus                    = "${var.vb_cpus}"
  disk_size               = "${var.vb_disk_size}"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Ubuntu_64"
  hard_drive_interface    = "sata"
  headless                = true
  http_directory          = "http"
  iso_checksum            = "${var.checksum_type}:${var.iso_checksum}"
  iso_urls                = ["iso/${var.iso_name}", "${var.mirror}/${var.mirror_directory}/${var.iso_name}"]
  memory                  = "${var.vb_memory}"
  output_directory        = "builds/virtualbox/aracpac-${var.image_name}-v${var.version}"
  sata_port_count         = 5
  shutdown_command        = "/usr/sbin/shutdown -P now"
  ssh_password            = "root"
  ssh_port                = 22
  ssh_timeout             = "10000s"
  ssh_username            = "root"
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "aracpac-${var.image_name}-v${var.version}"
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.virtualbox-iso.main"]

  provisioner "shell" {
    expect_disconnect = true
    pause_after       = "60s"
    scripts           = ["scripts/update.sh"]
  }

  provisioner "shell" {
    clean_staging_directory = true
    only                    = ["source.virtualbox-iso.main"]
    scripts                 = ["scripts/virtualbox.sh"]
  }

  provisioner "shell" {
    scripts           = ["scripts/ansible.sh", "scripts/sshd.sh", "scripts/networking.sh"]
  }

  provisioner "ansible-local" {
    clean_staging_directory = true
    extra_arguments         = ["--extra-vars", "'{}'"]
    galaxy_file             = "ansible/requirements.yml"
    playbook_dir            = "ansible"
    playbook_file           = "ansible/main.yml"
  }

  provisioner "shell" {
    expect_disconnect = true
    scripts           = ["scripts/cleanup.sh", "scripts/minimize.sh"]
  }

  post-processor "vagrant" {
    compression_level = "8"
    output            = "builds/${var.image_name}-v${var.version}.box"
  }
}

#### VARIABLES https://www.packer.io/docs/templates/hcl_templates/variables ############################################
########################################################################################################################

variable "checksum_type" {
  type    = string
  default = "sha256"
}

variable "image_name" {
  type    = string
  default = "ubuntu22"
}

variable "iso_checksum" {
  type    = string
  default = "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"
}

variable "iso_name" {
  type    = string
  default = "ubuntu-22.04-live-server-amd64.iso"
}

variable "mirror" {
  type    = string
  default = "http://releases.ubuntu.com"
}

variable "mirror_directory" {
  type    = string
  default = "22.04"
}

variable "vb_cpus" {
  type    = string
  default = "2"
}

variable "vb_disk_size" {
  type    = string
  default = "512000"
}

variable "vb_memory" {
  type    = string
  default = "2048"
}

variable "version" {
  type    = string
  default = "2.0.0"
}