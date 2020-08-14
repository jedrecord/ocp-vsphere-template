provider "ignition" {
  version = "1.1.0"
}

locals {
  mask = "${element(split("/", var.machine_cidr), 1)}"
  gw  = var.gateway_ip
  dns1 = var.dns1_ip
  dns2 = var.dns2_ip

  ignition_encoded = "data:text/plain;charset=utf-8;base64,${base64encode(var.ignition)}"
}

data "ignition_file" "hostname" {
  count = var.instance_count

  filesystem = "root"
  path       = "/etc/hostname"
  mode       = "420"

  content {
    content = "${var.name}${count.index}"
  }
}

data "ignition_file" "static_ip" {
  count = var.instance_count

  filesystem = "root"
  path       = "/etc/sysconfig/network-scripts/ifcfg-ens192"
  mode       = "420"

  content {
    content = <<EOF
TYPE=Ethernet
BOOTPROTO=none
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=${var.ip_addresses[count.index]}
PREFIX=${local.mask}
GATEWAY=${local.gw}
DOMAIN=${var.cluster_domain}
DNS1=${local.dns1}
DNS2=${local.dns2}
EOF
  }
}

data "ignition_systemd_unit" "restart" {
  count = var.instance_count

  name = "restart.service"

  content = <<EOF
[Unit]
ConditionFirstBoot=yes
[Service]
Type=idle
ExecStart=/sbin/reboot
[Install]
WantedBy=multi-user.target
EOF
}

data "ignition_config" "ign" {
  count = var.instance_count

  append {
    source = "${var.ignition_url != "" ? var.ignition_url : local.ignition_encoded}"
  }

  systemd = [
    data.ignition_systemd_unit.restart[count.index].id,
  ]

  files = [
    data.ignition_file.hostname[count.index].id,
    data.ignition_file.static_ip[count.index].id,
  ]
}
