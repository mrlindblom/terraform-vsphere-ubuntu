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
  count         = length(var.nodes)
  name          = var.nodes[count.index].vsphere_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count            = length(var.nodes)
  name             = var.nodes[count.index].hostname
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.nodes[count.index].vcpu
  memory   = var.nodes[count.index].memory_size

  guest_id = data.vsphere_virtual_machine.template[count.index].guest_id

  scsi_type = data.vsphere_virtual_machine.template[count.index].scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template[count.index].network_interface_types[0]
  }

  disk {
    label            = "os"
    size             = var.nodes[count.index].volume_size
    thin_provisioned = true
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      user-data = base64encode(templatefile("${path.module}/templates/cloud-init.yaml.tmpl", {
        hostname           = var.nodes[count.index].hostname
        hashed_passwd      = var.hashed_passwd
        server_init_base64 = var.server_init_base64
        authorized_keys    = var.authorized_keys
        username           = var.username
        netplan_base64 = base64encode(templatefile("${path.module}/templates/50-cloud-init.yaml.tmpl", {
          ip_addr     = var.nodes[count.index].ip_addr
          ip_gateway  = var.nodes[count.index].gateway
          domain      = var.nodes[count.index].domain
          nameservers = var.nodes[count.index].nameservers
        }))
      }))
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template[count.index].id
  }

  lifecycle {
    ignore_changes = [
      vapp
    ]
  }
}

output "template" {
  value = data.vsphere_virtual_machine.template

}
