# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "virtualbox-iso" "main" {
  boot_command            = ["<up><wait><tab>", "text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg", "<enter><wait>"]
  boot_wait               = "5s"
  cpus                    = "${var.vb_cpus}"
  disk_size               = "${var.vb_disk_size}"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "RedHat_64"
  hard_drive_interface    = "sata"
  headless                = true
  http_directory          = "http"
  iso_checksum            = "${var.checksum_type}:${var.iso_checksum}"
  iso_urls                = ["iso/${var.iso_name}", "${var.mirror}/${var.mirror_directory}/${var.iso_name}"]
  memory                  = "${var.vb_memory}"
  output_directory        = "builds/virtualbox/aracpac-${var.image_name}-v${var.version}"
  sata_port_count         = 5
  shutdown_command        = "/sbin/halt -h -p"
  ssh_password            = "root"
  ssh_port                = 22
  ssh_timeout             = "10000s"
  ssh_username            = "root"
  vboxmanage              = [["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "aracpac-${var.image_name}-v${var.version}"
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.virtualbox-iso.main"]

  provisioner "shell" {
    expect_disconnect = true
    pause_after       = "60s"
    scripts           = ["scripts/legacy_crypto.sh", "scripts/update.sh"]
  }

  provisioner "shell" {
    scripts           = ["scripts/virtualbox.sh", "scripts/ansible.sh", "scripts/sshd.sh", "scripts/networking.sh"]
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
  default = "file"
}

variable "image_name" {
  type    = string
  default = "centos9-stream"
}

variable "iso_checksum" {
  type    = string
  default = "https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso.SHA256SUM"
}

variable "iso_name" {
  type    = string
  default = "CentOS-Stream-9-latest-x86_64-dvd1.iso"
}

variable "mirror" {
  type    = string
  default = "https://download.cf.centos.org"
}

variable "mirror_directory" {
  type    = string
  default = "9-stream/BaseOS/x86_64/iso"
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
  default = "2.2.0"
}
