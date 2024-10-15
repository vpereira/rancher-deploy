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

variable "ssh_pub_keys" {
  type = string
}

variable "dns_server" {
  type = string
}

variable "proxmox_target_node" {
  type = string
}

variable "image_name" {
  type = string
}

variable "ipconfig0" {
  type = string
}