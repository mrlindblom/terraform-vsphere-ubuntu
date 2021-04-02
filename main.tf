data "vsphere_datacenter" "dc" {
  name = var.vcenter_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vcenter_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vcenter_cluster_name}/Resources/${var.vcenter_resource_pool}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vcenter_vmnetwork
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vcenter_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.hostname
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vcpu
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  enable_disk_uuid = true
  disk {
    label            = "os"
    size             = var.volume_size
    thin_provisioned = true
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      user-data = base64encode(templatefile("${path.module}/templates/cloud-init.yaml.tmpl", {
        hostname           = var.hostname
        hashed_passwd      = var.hashed_passwd
        server_init_base64 = var.server_init_base64
        authorized_keys    = var.authorized_keys
        username           = var.username
        config_files       = var.config_files
        netplan_base64 = base64encode(templatefile("${path.module}/templates/50-cloud-init.yaml.tmpl", {
          ip_addr     = var.ip_addr
          ip_gateway  = var.ip_gateway
          domain      = var.domain
          nameservers = var.nameservers
        }))
      }))
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  lifecycle {
    ignore_changes = [
      vapp
    ]
  }
}
