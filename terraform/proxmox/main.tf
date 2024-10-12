provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id 
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
  pm_debug = true
}

resource "proxmox_vm_qemu" "microos_vm" {
  name        = "k3s-clone"
  target_node = "proxmox2" 
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
          size = "32G"
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
  ipconfig0 = "ip=192.168.0.11/24,gw=192.168.0.1"  # Adjust the gateway as needed
  sshkeys   = <<EOF
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDxwi9Lg3SNYHJexc65pDeG89ZvPwciGrWFXwyS0Tu/XVWn59z6unqffU5IkilgZpIq7xBdiX42sjdWAmOCpeKn2FfsRDUTXf547E9bd5oguTpwObyGJuXKrsxo3GAg5lAhgY1bTqgnuH6z8YtShlTWWYbGdamlxnhOrk0QOaBR2Par9chqFjcbv/F15SVOkJc5qAiJE/oSBzitqR/LbkN98TOLnLEKn4oN6xcalmOdn0oRcPskHjRiOImpxLKcB159bbRbSxafg6/8IOzPPmjM3ILwoFG8LQ4rMnKvI62o7o7IJfc8IS6WSlkVkUSRaFFXdWxZJuC77BSQXl2ctJT3 vpereira@linux-88ja
  EOF
  nameserver = "192.168.0.18"
}

