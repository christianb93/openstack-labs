###############################################################################
# Variables and global configuration
###############################################################################

# The location where we search for the key for the service account
variable "gcp_service_account_key" {
  type = string
  default = "~/.keys/gcp_service_account.json"
}

# Get the ID of the project that we use from our service account key 
locals {
  key_data = jsondecode(file("${var.gcp_service_account_key}"))
}

# The region in which we bring up our resources
variable "region" {
  type = string
  default = "europe-west3"
}

# The zone in which we bring up our resources
variable "zone" {
  type = string
  default = "europe-west3-c"
}

# The file in which the public key for the stack user is stored
variable "stack_public_ssh_key_file" {
  type = string
  default = "~/.ssh/gcp-default-key.pub"
}

# The file in which the private key for the stack user is stored
variable "stack_private_ssh_key_file" {
  type = string
  default = "~/.ssh/gcp-default-key"
}


# Define provider, region, zone and project and
# specify location of credentials for the service account that we use
provider "google" {
  credentials = "${file(var.gcp_service_account_key)}"
  project     = local.key_data.project_id
  region = var.region
  zone = var.zone
}

# The following variables define the CIDR ranges that we will use for the various networks that
# we establish
variable "management_network_cidr" {
  type = string
  default = "192.168.1.0/24"
}
variable "public_network_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "underlay_network_cidr" {
  type = string
  default = "192.168.2.0/24"
}

# The number of compute  nodes that we use
variable "compute_node_count" {
  type = number
  default = 2
}


# IP address of the machine on which Terraform is running
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

###############################################################################
# Networks
###############################################################################

# Create a VPC which will be our public network
resource "google_compute_network" "public-vpc" {
  name                    = "public-vpc"
  description             = "Public network, i.e. network to which all network interfaces with public IP addresses will be attached"
  auto_create_subnetworks = false
}

# Create a subnetwork within this VPC
resource "google_compute_subnetwork" "public-subnetwork" {
  name          = "public-subnetwork"
  ip_cidr_range = var.public_network_cidr
  network       = google_compute_network.public-vpc.self_link
  region = var.region
}

# Add firewall rules to allow incoming ICMP and SSH traffic as well as port 80 (for Horizon)
# and 6080 (for the VNC console) and the API ports
resource "google_compute_firewall" "public-firewall" {
  name    = "public-firewall"
  network = google_compute_network.public-vpc.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol      = "tcp"
    ports         = ["5000", "8774", "8776", "8778", "9696", "9292", "9876", "22", "443", "6080"]
  }

  # If you loose connectivity to your instance and want to use the browser-based
  # SSH from Google's console, uncomment the line below and re-apply 
  source_ranges = ["${chomp(data.http.myip.body)}/32"]

}

# Create a VPC which will be our management network
resource "google_compute_network" "management-vpc" {
  name                    = "management-vpc"
  description             = "Management network"
  auto_create_subnetworks = false
}

# Create a subnetwork within this VPC
resource "google_compute_subnetwork" "management-subnetwork" {
  name          = "management-subnetwork"
  ip_cidr_range = var.management_network_cidr
  network       = google_compute_network.management-vpc.self_link
  region        = var.region
  
}

# Add firewall rules to allow all incoming traffic on the management network
resource "google_compute_firewall" "management-firewall" {
  name    = "management-firewall"
  network = google_compute_network.management-vpc.self_link

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }
  
  source_ranges = ["${var.management_network_cidr}"]
  
}

# Create a VPC which will be our underlay network
resource "google_compute_network" "underlay-vpc" {
  name                    = "underlay-vpc"
  description             = "Underlay network"
  auto_create_subnetworks = false
}

# Create a subnetwork within this VPC
resource "google_compute_subnetwork" "underlay-subnetwork" {
  name          = "underlay-subnetwork"
  ip_cidr_range = var.underlay_network_cidr
  network       = google_compute_network.underlay-vpc.self_link
  region        = var.region
  
}

# Add firewall rules to allow all incoming traffic on the management network
resource "google_compute_firewall" "underlay-firewall" {
  name    = "underlay-firewall"
  network = google_compute_network.underlay-vpc.self_link

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }
  
  source_ranges = ["${var.underlay_network_cidr}"]
  
}


###############################################################################
# The image. To make nested virtualization work, we need an image with a 
# specific license. To create the image, we need a disk (which we could actually
# delete again once the image exists)
# see https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances
###############################################################################

resource "google_compute_disk" "dummy_disk" {
  name  = "dummy-disk"
  image = "ubuntu-os-cloud/ubuntu-1804-lts"
}

resource "google_compute_image" "ubuntu_bionic_nested_virtualization" {
  name = "my-ubuntu-image"
  source_disk = google_compute_disk.dummy_disk.self_link
  # We need to specify both licenses, otherwise the image will be recreated when we run
  # Terraform again, and this will force re-creation of all instances
  licenses = [
    "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/licenses/ubuntu-1804-lts",
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx",
  ]
}


###############################################################################
# Instances
###############################################################################

# The controller node
resource "google_compute_instance" "controller" {
  name         = "controller"
  machine_type = "n1-standard-2"

  boot_disk {
    initialize_params {
      image = google_compute_image.ubuntu_bionic_nested_virtualization.self_link
    }
  }
  # We add a user stack with an SSH key
  metadata = {
    ssh-keys = "stack:${file(var.stack_public_ssh_key_file)}"
  }

  metadata_startup_script = "sudo apt-get -y remove sshguard"
  
  network_interface {
    # This is the public interface, attached to our public network
    network       = google_compute_network.public-vpc.self_link
    subnetwork    = google_compute_subnetwork.public-subnetwork.self_link
    access_config {
    }
  }

  network_interface {
    # This is the management interface, attached to our management network
    network       = google_compute_network.management-vpc.self_link
    subnetwork    = google_compute_subnetwork.management-subnetwork.self_link
    network_ip    = "192.168.1.11"
  }

} 


# The network node
resource "google_compute_instance" "network" {
  name         = "network"
  machine_type = "n1-standard-4"

  boot_disk {
    initialize_params {
      image = google_compute_image.ubuntu_bionic_nested_virtualization.self_link
    }
  }
  # We add a user stack with an SSH key
  metadata = {
    ssh-keys = "stack:${file(var.stack_public_ssh_key_file)}"
  }

  metadata_startup_script = "sudo apt-get -y remove sshguard"
  
  network_interface {
    # This is the public interface, attached to our public network
    network       = google_compute_network.public-vpc.self_link
    subnetwork    = google_compute_subnetwork.public-subnetwork.self_link
    access_config {
    }
  }

  network_interface {
    # This is the management interface, attached to our management network
    network       = google_compute_network.management-vpc.self_link
    subnetwork    = google_compute_subnetwork.management-subnetwork.self_link
    network_ip    = "192.168.1.12"
  }

  network_interface {
    # This is the underlay interface, attached to our management network
    network       = google_compute_network.underlay-vpc.self_link
    subnetwork    = google_compute_subnetwork.underlay-subnetwork.self_link
    network_ip    = "192.168.2.12"
  }

} 

# The compute nodes
resource "google_compute_instance" "compute" {
  name         = "compute${count.index}"
  machine_type = "n1-standard-2"
  count = var.compute_node_count

  boot_disk {
    initialize_params {
      image = google_compute_image.ubuntu_bionic_nested_virtualization.self_link
    }
  }
  # We add a user stack with an SSH key
  metadata = {
    ssh-keys = "stack:${file(var.stack_public_ssh_key_file)}"
  }

  network_interface {
    # This is the management interface, attached to our management network
    network       = google_compute_network.management-vpc.self_link
    subnetwork    = google_compute_subnetwork.management-subnetwork.self_link
    network_ip    = "192.168.1.2${count.index+1}"
  }

  network_interface {
    # This is the underlay interface, attached to our management network
    network       = google_compute_network.underlay-vpc.self_link
    subnetwork    = google_compute_subnetwork.underlay-subnetwork.self_link
    network_ip    = "192.168.2.2${count.index+1}"
  }

}

# Storage node and associated disk
resource "google_compute_disk" "lvm_volume" {
  name          = "lvm-volume"
  description   = "This is the disk that LVM will use as a physical volume"
  size          = 20
}
resource "google_compute_instance" "storage" {
  name         = "storage"
  machine_type = "n1-standard-1"
  
  boot_disk {
    initialize_params {
      image = google_compute_image.ubuntu_bionic_nested_virtualization.self_link
    }
  }

  attached_disk {
    source        = google_compute_disk.lvm_volume.self_link
    device_name   = "lvm-volume"
  }

  # We add a user stack with an SSH key
  metadata = {
    ssh-keys = "stack:${file(var.stack_public_ssh_key_file)}"
  }

  network_interface {
    # This is the management interface, attached to our management network
    network       = google_compute_network.management-vpc.self_link
    subnetwork    = google_compute_subnetwork.management-subnetwork.self_link
    network_ip    = "192.168.1.31"
   }
}

output "inventory" {
  value = concat(
      [ {
        # the Ansible groups to which we will assign the server
        "groups"           : "['controller_nodes', 'install_node']",
        "name"             : "${google_compute_instance.controller.name}",
        "ip"               : "${google_compute_instance.controller.network_interface.0.access_config.0.nat_ip }",
        "mgmt_ip"          : "${google_compute_instance.controller.network_interface.1.network_ip}",
        "underlay_ip"      : "",
        "ansible_ssh_user" : "stack",
        "private_key_file" : "${var.stack_private_ssh_key_file}",
        "ssh_args"         : "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" 
      } ],
      [ {
        "groups"           : "['network_nodes']",
        "name"             : "${google_compute_instance.network.name}",
        "ip"               : "${google_compute_instance.network.network_interface.0.access_config.0.nat_ip }",
        "mgmt_ip"          : "${google_compute_instance.network.network_interface.1.network_ip}",
        "underlay_ip"      : "${google_compute_instance.network.network_interface.2.network_ip}",
        "ansible_ssh_user" : "stack",
        "private_key_file" : "${var.stack_private_ssh_key_file}",
        "ssh_args"         : "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" 
      } ],
      [ {
        "groups"           : "['storage_nodes']",
        "name"             : "${google_compute_instance.storage.name}",
        "ip"               : "${google_compute_instance.storage.network_interface.0.network_ip }",
        "mgmt_ip"          : "${google_compute_instance.storage.network_interface.0.network_ip}",
        "underlay_ip"      : "",
        "ansible_ssh_user" : "stack",
        "private_key_file" : "${var.stack_private_ssh_key_file}",
        "extra_ssh_config_items"  :  "ProxyJump network",
        "ssh_args"         : "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o \"ProxyCommand ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.stack_private_ssh_key_file} -W %h:%p stack@${google_compute_instance.network.network_interface.0.access_config.0.nat_ip}\"" 
      } ],
      [ for s in google_compute_instance.compute[*] : {
        # Note that we use the management IP as SSH target IP as we use the network node as the jump host
        "groups"                : "['compute_nodes']",
        "name"                    : "${s.name}",
        "ip"                      : "${s.network_interface.0.network_ip}",
        "mgmt_ip"                 : "${s.network_interface.0.network_ip}",
        "underlay_ip"             : "${s.network_interface.1.network_ip}",
        "ansible_ssh_user"        : "stack",
        "private_key_file"        : "${var.stack_private_ssh_key_file}",
        "extra_ssh_config_items"  :  "ProxyJump network",
        "ssh_args"                : "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o \"ProxyCommand ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.stack_private_ssh_key_file} -W %h:%p stack@${google_compute_instance.network.network_interface.0.access_config.0.nat_ip}\"" 
      } ]
   )
}
