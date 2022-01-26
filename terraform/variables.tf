variable "vsphere_server" {
}

variable "vsphere_user" {
}

variable "vsphere_password" {
}

variable "datacenter_name" {
}

variable "datastore_cluster" { 
}

variable "cluster_name" {
}

variable "network_name" {
}

variable "template_name" {
}

variable "k8s" {
  type = list
  default = []
}

variable "domain_name" {
}

variable "vmdk" {
}

variable "dnsserver" {
}
