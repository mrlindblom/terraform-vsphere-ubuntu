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

variable "vcenter_cluster_name" {
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

variable "hostname" {
  type = string
}

variable "vcenter_template" {
  type = string
}

variable "vcpu" {
  type = number
}

variable "volume_size" {
  type = number
}

variable "memory" {
  type = number
}

variable "ip_addr" {
  type = string
}

variable "ip_gateway" {
  type = string
}

variable "server_init_base64" {
  type    = string
  default = null
}

variable "domain" {
  type    = string
  default = "domain.local"
}

variable "nameservers" {
  type = string
}

variable "hashed_passwd" {
  type    = string
  default = null
}

variable "authorized_keys" {
  type = list(string)
}

variable "username" {
  type    = string
  default = "sysop"
}
