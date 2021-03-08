variable "vcenter_user" {
  type = string
}

variable "vcenter_password" {
  type = string
}

variable "vcenter_server" {
  type = string
}

variable "vcenter_datacenter" {
  type = string
}

variable "vcenter_resource_pool" {
  type = string
}

variable "vcenter_datastore" {
  type = string
}

variable "vcenter_vmnetwork" {
  type = string
}

variable "server_init_base64" {
  type    = string
  default = null
}

variable "hashed_passwd" {
  type    = string
  default = null
}

variable "authorized_keys" {
  type    = list(string)
  default = null
}

variable "username" {
  type    = string
  default = "sysop"
}

variable "nodes" {
  type = list(object({
    ip_addr          = string
    gateway          = string
    nameservers      = string
    hostname         = string
    domain           = string
    roles            = list(string)
    port             = number
    user             = string
    vcpu             = number
    volume_size      = number
    memory_size      = number
    vsphere_template = string
  }))
  default = [
    {
      ip_addr          = null
      gateway          = null
      nameservers      = null
      hostname         = null
      domain           = null
      roles            = null
      port             = null
      user             = null
      vcpu             = 2
      volume_size      = 50
      memory_size      = 2048
      vsphere_template = null
    }
  ]
}
