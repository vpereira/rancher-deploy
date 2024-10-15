provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id 
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
  pm_debug = true
}

resource "proxmox_vm_qemu" "microos_vm" {
  name        = var.image_name
  target_node = var.proxmox_target_node
  clone       = "k3s"
  agent = 1
  scsihw = "virtio-scsi-single"
  memory = 4096
  cpu = "host"
  sockets = 1
  cores = 4

  disks {
    ide {
      ide0 {
        cdrom {}
      }
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size = "40G"
          storage = "local-lvm"
        }
      }
    }
  }

  boot = "order=scsi0"

  # Network Configuration
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-init Configuration
  ipconfig0 = var.ipconfig0
  sshkeys = var.ssh_pub_keys
  nameserver = var.dns_server
}

