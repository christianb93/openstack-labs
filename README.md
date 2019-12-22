# openstack-labs

A collection of scripts and Ansible playbooks around OpenStack. Here is a list of the labs currently implemented.

* Lab1 - set up the playground and install basic infrastructure services
* Lab2 - Install Keystone
* Lab3 - Install Glance and Placement
* Lab4 - Install Nova
* Lab5 - Install Neutron in a very basic setup (one flat network only)
* Lab6 - Add the Horizon GUI
* Lab7 - Add a VLAN network as a provider network
* Lab8 - Install a virtual router using the Neutron L3 agent
* Lab9 - Allow a tenant to provision VXLAN networks
* Lab10 - Introduce a separate network node on which the Neutron agents run

In addition, this repository contains scripts to bring up an OpenStack playground on various cloud platform - a cloud in the cloud.

* Packet - provision a Packet.net bare metal instance and install a lab there
* DigitalOcean - provision a Droplet on DigitalOcean and use that as a lab host

