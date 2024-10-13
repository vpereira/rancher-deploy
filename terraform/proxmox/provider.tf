terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc4" # Eventually the 3.0 version?
    }
  }
}


variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
    sensitive = true
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "base_image" {
  type = string
}

variable "ssh_pub_keys" {
  type = string
}

variable "dns_server" {
  type = string
}

variable "proxmox_target_node" {
  type = string
}

variable "number_of_vms" {
  type = number
  default = 1
}

variable "vm_name" {
  description = "Base name of the VM"
  type        = string
  default     = "microos-vm"
}

variable "vm_ips" {
  description = "List of IPs to assign to VMs"
  type        = list(string)
  default     = ["192.168.0.11", "192.168.0.12", "192.168.0.13"]
}
