router
=========

This role will establish routing rules on a network node to be able to reach the public network from the OpenStack instances. It will

* enable forwarding on the node, so that traffic from the internal interface (for instance a bridge like br-ext) can be forwarded to the public interface
* set the default forwarding policy to DROP
* allow forwarding for traffic coming from the internal interface
* allow forwarding for traffic coming from the external interface if the traffic belongs to an established connection
* add a SNAT rule for all traffic leaving the node via the public interface
* block all new connections to the network node itself (INPUT) from the public interface except SSH traffic 
* bring up the internal interface and assign an IP address 

To make sure that the rules are restored at boot time, we install iptables-persistent and write our rules to /etc/iptables/rules.v4

Requirements
------------

We assume that iptables is installed. Also note that this role conflicts with  ufw! So if ufw is installed on the network node, you will have to disable it first!


Role Variables
--------------

The following variables need to be set when calling this role.

* public_interface - the public interface of the network node, typically something like enp0s3
* internal_interface - the internal interface to use
* internal_ip_address - the IP address to be used for the br-ext interface, including CIDR. This will typically be the gateway CIDR of a flat network on br-phys

For the following variable, a default is defined

* internal_interface_mtu - the MTU to set on the internal interface


Dependencies
------------

iptables needs to be installed on the node


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
