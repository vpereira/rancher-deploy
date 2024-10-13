provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id 
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
  pm_debug = true
}

resource "proxmox_vm_qemu" "microos_vm" {
  count       = var.number_of_vms
  name        = "${var.vm_name}-${count.index}"
  target_node = var.proxmox_target_node
  clone       = var.base_image
  agent       = 1
  scsihw      = "virtio-scsi-single"
  memory      = 4096
  cpu         = "host" # Is CPU Host the best option?
  sockets     = 1
  cores       = 4

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
  ipconfig0 = "ip=${var.vm_ips[count.index]}/24,gw=192.168.0.1"
  sshkeys   = var.ssh_pub_keys
  nameserver = var.dns_server
}

