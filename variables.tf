# vSphere config
variable "vsphere_server" {
  type        = string
  description = "This is the vSphere server for the environment."
}

variable "vsphere_user" {
  type        = string
  description = "vSphere server user for the environment."
}

variable "vsphere_password" {
  type        = string
  description = "vSphere server password"
}

variable "vsphere_cluster" {
  type        = string
  description = "This is the name of the vSphere cluster."
}

variable "vsphere_datacenter" {
  type        = string
  description = "This is the name of the vSphere data center."
}

variable "vsphere_datastore" {
  type        = string
  description = "This is the name of the vSphere data store."
}

variable "vm_template" {
  type        = string
  description = "This is the name of the VM template to clone."
}

variable "vm_network" {
  type        = string
  description = "This is the name of the publicly accessible network for cluster ingress and access."
  default     = "VM Network"
}

variable "compute_portgroup" {
  type        = string
  description = "This is the name of the distributed portgroup for the internal network"
  default     = "compute_network"
}

variable "ipam" {
  type        = string
  description = "The IPAM server to use for IP management."
  default     = ""
}

variable "ipam_token" {
  type        = string
  description = "The IPAM token to use for requests."
  default     = ""
}

# OpenShift cluster config
variable "cluster_id" {
  type        = string
  description = "This cluster id must be of max length 27 and must have only alphanumeric or hyphen characters."
}

variable "base_domain" {
  type        = string
  description = "The base DNS zone to add the sub zone to."
}

variable "cluster_domain" {
  type        = string
  description = "The base DNS zone to add the sub zone to."
}

variable "machine_cidr" {
  type = string
}

variable "gateway_ip" {
  type = string
}

variable "dns1_ip" {
  type = string
}

variable "dns2_ip" {
  type = string
}

# Bootstrap vm
variable "bootstrap_prefix" {
  type    = string
  default = "bootstrap"
}

variable "bootstrap_complete" {
  type    = string
  default = "false"
}

variable "bootstrap_ignition_url" {
  type = string
}

variable "bootstrap_ip" {
  type    = string
  default = ""
}

variable "bootstrap_num_cpus" {
  type    = string
  default = "4"
}

variable "bootstrap_memory" {
  type    = string
  default = "8192"
}

variable "bootstrap_disk_size" {
  type    = string
  default = "60"
}

# Control_Plane vms
variable "control_plane_prefix" {
  type    = string
  default = "control_plane"
}

variable "control_plane_count" {
  type    = string
  default = "3"
}

variable "control_plane_ignition" {
  type = string
}

variable "control_plane_ips" {
  type    = list(string)
  default = []
}

variable "control_plane_num_cpus" {
  type    = string
  default = "4"
}

variable "control_plane_memory" {
  type    = string
  default = "16384"
}

variable "control_plane_disk_size" {
  type    = string
  default = "60"
}

# Compute vms
variable "compute_prefix" {
  type    = string
  default = "compute"
}

variable "compute_count" {
  type    = string
  default = "3"
}

variable "compute_ignition" {
  type = string
}

variable "compute_ips" {
  type    = list(string)
  default = []
}

variable "compute_num_cpus" {
  type    = string
  default = "4"
}

variable "compute_memory" {
  type    = string
  default = "16384"
}

variable "compute_disk_size" {
  type    = string
  default = "80"
}

# Distributed Switch
variable "esxi_hosts" {
  type    = list(string)
  default = []
}

variable "esxi_interfaces" {
  type    = list(string)
  default = []
}
