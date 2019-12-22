###############################################################################
# Variables and global configuration
###############################################################################

# The location where we search for the key for the service account
variable "gcp_service_account_key" {
  type = string
  default = "~/.gcp_service_account.json"
}

# The ID of the project that we use and in which all our resources live
variable "project_id" {
  type = string
  default = "openstack-project-id"
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

# The file in which the public key for the vagrant user is stored
variable "vagrant_public_ssh_key_file" {
  type = string
  default = "~/.ssh/gcp-default-key.pub"
}

# The file in which the private key for the vagrant user is stored
variable "vagrant_private_ssh_key_file" {
  type = string
  default = "~/.ssh/gcp-default-key"
}


# Define provider, region, zone and project and
# specify location of credentials for the service account that we use
provider "google" {
  credentials = "${file(var.gcp_service_account_key)}"
  project     = var.project_id
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
# and 6080 (for the VNC console)
resource "google_compute_firewall" "public-firewall" {
  name    = "public-firewall"
  network = google_compute_network.public-vpc.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol      = "tcp"
    ports         = ["22", "80", "6080"]
  }

  # source_ranges = ["${chomp(data.http.myip.body)}/32"]

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
# Instances
###############################################################################

# The controller node
resource "google_compute_instance" "controller" {
  name         = "controller"
  machine_type = "n1-standard-2"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  # We add a user vagrant with an SSH key
  metadata = {
    ssh-keys = "vagrant:${file(var.vagrant_public_ssh_key_file)}"
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
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  # We add a user vagrant with an SSH key
  metadata = {
    ssh-keys = "vagrant:${file(var.vagrant_public_ssh_key_file)}"
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


resource "google_compute_instance" "compute" {
  name         = "compute${count.index}"
  machine_type = "n1-standard-2"
  count = 2

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  # We add a user vagrant with an SSH key
  metadata = {
    ssh-keys = "vagrant:${file(var.vagrant_public_ssh_key_file)}"
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


output "inventory" {
  value = concat(
      [ {
        # the Ansible groups to which we will assign the server
        "groups"           : "['controller_nodes', 'install_node']",
        "name"             : "${google_compute_instance.controller.name}",
        "ip"               : "${google_compute_instance.controller.network_interface.0.access_config.0.nat_ip }",
        "mgmt_ip"          : "${google_compute_instance.controller.network_interface.1.network_ip}",
        "underlay_ip"      : "",
        "ansible_ssh_user" : "vagrant",
        "private_key_file" : "${var.vagrant_private_ssh_key_file}",
        "ssh_args"         : "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" 
      } ],
      [ {
        "groups"           : "['network_nodes']",
        "name"             : "${google_compute_instance.network.name}",
        "ip"               : "${google_compute_instance.network.network_interface.0.access_config.0.nat_ip }",
        "mgmt_ip"          : "${google_compute_instance.network.network_interface.1.network_ip}",
        "underlay_ip"      : "${google_compute_instance.network.network_interface.2.network_ip}",
        "ansible_ssh_user" : "vagrant",
        "private_key_file" : "${var.vagrant_private_ssh_key_file}",
        "ssh_args"         : "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" 
      } ],
      [ for s in google_compute_instance.compute[*] : {
        # Note that we use the management IP as SSH target IP as we use the network node as the jump host
        "groups"                : "['compute_nodes']",
        "name"                    : "${s.name}",
        "ip"                      : "${s.network_interface.0.network_ip}",
        "mgmt_ip"                 : "${s.network_interface.0.network_ip}",
        "underlay_ip"             : "${s.network_interface.1.network_ip}",
        "ansible_ssh_user"        : "vagrant",
        "private_key_file"        : "${var.vagrant_private_ssh_key_file}",
        "extra_ssh_config_items"  :  "ProxyJump network",
        "ssh_args"                : "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o \"ProxyCommand ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.vagrant_private_ssh_key_file} -W %h:%p vagrant@${google_compute_instance.network.network_interface.0.access_config.0.nat_ip}\"" 
      } ]
   )
}
