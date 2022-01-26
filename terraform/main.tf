provider "vsphere" {
  vsphere_server = "${var.vsphere_server}"
  user = "${var.vsphere_user}"
  password = "${var.vsphere_password}"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.datacenter_name}"
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = "${var.datastore_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name 		= "${var.cluster_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "mgmt_lan_0" {
  name          = "${var.network_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name		= "${var.template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "k8s" {
  count			= "${length(var.k8s)}"
  name             	= "${lookup(var.k8s[count.index], "vm_name")}.${var.domain_name}"
  resource_pool_id 	= "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_cluster_id	= "${data.vsphere_datastore_cluster.datastore_cluster.id}"

  num_cpus   = 2
  memory     = 2048
  wait_for_guest_net_timeout = 0
  guest_id   = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type  = "${data.vsphere_virtual_machine.template.scsi_type}"
  
  network_interface {
    network_id     = "${data.vsphere_network.mgmt_lan_0.id}"
    adapter_type   = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    size             = 12
    label	     = "${lookup(var.k8s[count.index], "vm_name")}.${var.domain_name}${var.vmdk}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid    = "${data.vsphere_virtual_machine.template.id}"

  customize {
    linux_options {
      host_name = "${lookup(var.k8s[count.index], "vm_name")}"
      domain 	= "${var.domain_name}"
    }

  network_interface {
    ipv4_address = "${lookup(var.k8s[count.index], "ipaddress")}"
    ipv4_netmask = "24"
  }

  ipv4_gateway = "172.16.2.1"
  dns_server_list = ["${var.dnsserver}"]
  }
}
}
