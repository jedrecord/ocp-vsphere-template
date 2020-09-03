variable "name" {
  type = string
}

variable "instance_count" {
  type = string
}

variable "ignition" {
  type    = string
  default = ""
}

variable "ignition_url" {
  type    = string
  default = ""
}

variable "resource_pool_id" {
  type = string
}

variable "folder" {
  type = string
}

variable "datastore" {
  type = string
}

variable "cluster_domain" {
  type = string
}

variable "datacenter_id" {
  type = string
}

variable "template" {
  type = string
}

variable "machine_cidr" {
  type = string
}

variable "ip_addresses" {
  type = list
}
variable "memory" {
  type = string
}

variable "num_cpu" {
  type = string
}

variable "disk_size" {
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

variable "portgroup_id" {
  type = string
}