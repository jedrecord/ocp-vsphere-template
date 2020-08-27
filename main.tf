provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  version              = "1.23"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  count         = length(var.esxi_hosts)
  name          = var.esxi_hosts[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

# DRS Enabled Resource Pool
resource "vsphere_resource_pool" "resource_pool" {
  name                    = var.cluster_id
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}

resource "vsphere_folder" "folder" {
  path          = var.cluster_id
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_distributed_virtual_switch" "dvs" {
  name          = "DS_${var.compute_portgroup}"
  datacenter_id = data.vsphere_datacenter.dc.id

  uplinks         = ["uplink1", "uplink2", "uplink3", "uplink4"]
  active_uplinks  = ["uplink1", "uplink2"]
  standby_uplinks = ["uplink3", "uplink4"]

  host {
    host_system_id = data.vsphere_host.host.0.id
    devices        = var.esxi_interfaces
  }

  host {
    host_system_id = data.vsphere_host.host.1.id
    devices        = var.esxi_interfaces
  }

  host {
    host_system_id = data.vsphere_host.host.2.id
    devices        = var.esxi_interfaces
  }

 host {
    host_system_id = data.vsphere_host.host.3.id
    devices        = var.esxi_interfaces
  }
}

resource "vsphere_distributed_port_group" "pg" {
  name                            = var.compute_portgroup
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.dvs.id

  vlan_id = 1033
}

module "bootstrap" {
  source = "./machine"

  name             = var.bootstrap_prefix
  instance_count   = var.bootstrap_complete ? 0 : 1
  ignition_url     = var.bootstrap_ignition_url
  resource_pool_id = vsphere_resource_pool.resource_pool.id
  datastore        = var.vsphere_datastore
  folder           = vsphere_folder.folder.path
  portgroup_id     = vsphere_distributed_port_group.pg.id
  datacenter_id    = data.vsphere_datacenter.dc.id
  template         = var.vm_template
  cluster_domain   = var.cluster_domain
  ipam             = var.ipam
  ipam_token       = var.ipam_token
  gateway_ip       = var.gateway_ip
  dns1_ip          = var.dns1_ip
  dns2_ip          = var.dns2_ip
  ip_addresses     = compact([var.bootstrap_ip])
  machine_cidr     = var.machine_cidr
  memory           = var.bootstrap_memory
  num_cpu          = var.bootstrap_num_cpus
  disk_size        = var.bootstrap_disk_size
}

module "control_plane" {
  source = "./machine"

  name             = var.control_plane_prefix
  instance_count   = var.control_plane_count
  ignition         = var.control_plane_ignition
  resource_pool_id = vsphere_resource_pool.resource_pool.id
  folder           = vsphere_folder.folder.path
  datastore        = var.vsphere_datastore
  portgroup_id     = vsphere_distributed_port_group.pg.id
  datacenter_id    = data.vsphere_datacenter.dc.id
  template         = var.vm_template
  cluster_domain   = var.cluster_domain
  ipam             = var.ipam
  ipam_token       = var.ipam_token
  gateway_ip       = var.gateway_ip
  dns1_ip          = var.dns1_ip
  dns2_ip          = var.dns2_ip
  ip_addresses     = var.control_plane_ips
  machine_cidr     = var.machine_cidr
  memory           = var.control_plane_memory
  num_cpu          = var.control_plane_num_cpus
  disk_size        = var.control_plane_disk_size
}

module "compute" {
  source = "./machine"

  name             = var.compute_prefix
  instance_count   = var.compute_count
  ignition         = var.compute_ignition
  resource_pool_id = vsphere_resource_pool.resource_pool.id
  folder           = vsphere_folder.folder.path
  datastore        = var.vsphere_datastore
  portgroup_id     = vsphere_distributed_port_group.pg.id
  datacenter_id    = data.vsphere_datacenter.dc.id
  template         = var.vm_template
  cluster_domain   = var.cluster_domain
  ipam             = var.ipam
  ipam_token       = var.ipam_token
  gateway_ip       = var.gateway_ip
  dns1_ip          = var.dns1_ip
  dns2_ip          = var.dns2_ip
  ip_addresses     = var.compute_ips
  machine_cidr     = var.machine_cidr
  memory           = var.compute_memory
  num_cpu          = var.compute_num_cpus
  disk_size        = var.compute_disk_size
}

