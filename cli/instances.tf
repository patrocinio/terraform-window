provider "softlayer" {
}

variable "datacenter" {
  description = "SoftLayer datacenter where infrastructure resources will be deployed"
  default = "wdc04"

}


variable "instance_name" {
  description = "Virtual Machine name"
  default = "windows"
}

variable "domain" { 
    description = "Virtual Machine domain"
    default = "windows.patro" 
}

variable "public_key_name" {
  description = "Name of the public SSH key used to connect to the servers"
  default     = "patro-key"
}


variable "public_key" {
  description = "Public SSH key used to connect to the servers"
}





variable "windows" {
  type = "map"
  
  default = {
    nodes       = "1"
    cpu_cores   = "1"
    disk_size   = "100" // GB
    local_disk  = false
    memory      = "2048"
    network_speed= "1000"
    private_network_only=false
    hourly_billing=true
  }
 
}

resource "softlayer_ssh_key" "public_key" {
  label      = "${var.public_key_name}"
  public_key = "${var.public_key}"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

#resource "softlayer_compute_vm_instance" "windows" {
resource "softlayer_virtual_guest" "windows" {
    
    datacenter  = "${var.datacenter}"
    domain      = "${var.domain}"
    hostname    = "${var.instance_name}"
    
    os_reference_code = "WIN_2016-STD_64"

    cores       = "${var.windows["cpu_cores"]}"
    memory      = "${var.windows["memory"]}"
    disks       = ["${var.windows["disk_size"]}"]
    local_disk  = "${var.windows["local_disk"]}"
    network_speed         = "${var.windows["network_speed"]}"
    hourly_billing        = "${var.windows["hourly_billing"]}"
    private_network_only  = "${var.windows["private_network_only"]}"

    user_metadata = "{\"value\":\"newvalue\"}"

    ssh_key_ids              = ["${softlayer_ssh_key.public_key.id}"]
}

#module "provision" {
#    source = "github.com/softlayer-cloud-architecture/terraform-module-wps-deploy"

#    wps = "${softlayer_virtual_guest.wps.ipv4_address}"
#    wps = "${softlayer_compute_vm_instance.wps.ipv4_address}"
#    ssh_key = "${tls_private_key.ssh.private_key_pem}"
#}



