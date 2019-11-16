packet
=========

Provision a machine on Packet.net. In addition, this script will add the resulting server dynamically to the inventory and will create an SSH configuration file that is included in the main SSH configuration file ~/.ssh/config. The machines will be provisioned using Ubuntu Bionic as OS image.

Requirements
------------

This role assumes that the environment PACKET_API_TOKEN contains a valid Packet token

Role Variables
--------------

For the following variables, defaults are defined but can be overridden.

packetKeyFile - the private key of an SSH key pair. The script assumes that the matching public key is stored in a file with the same name with suffix *.pub* and will upload this key to Packet, so that it is automatically added the the authorized keys for the root user
packetKeyName - the name that we use to upload the SSH key to Packet
packetFacilitySlug - the Packet facility where we bring up the machine 
machineCount - the number of servers that we start
nameRoot - the root part of the name. The servers will be called {{nameRoot}}1, ... starting with index 1
packetSSHConfigFile - the name of the SSH configuration file that we create

Dependencies
------------

None

License
-------

MIT

Author Information
------------------

Visit me on https://www.github.com/christianb93
