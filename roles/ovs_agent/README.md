ovs_agent
=========

This role installs the OVS agent on a node. Note that it does not provide the neutron.conf configuration file, so this is only a partial setup!


The following changes are made to the configuration file openvswitch_agent.ini

* We define the bridge mappings, mapping our physical network to bridge names
* we define the firewall driver to use
* and we enable security groups



Requirements
------------

None

Role Variables
--------------

The following variables need to be set when calling this role.

* type_drivers - comma-separated list of the type driver that we want to support
* tenant_network_types - comma-separated list of network types that we make available as project networks, can be emtpy
* flat_networks - comma-separated list of flat networks that we provide
* ovs_bridge_mappings - OVS agent bridge mappings, like "physnet:br-phys". There needs to be one mapping for each network that we define

For the following variables, defaults are defined:

* ovs_tunnel_types - supported overlay network types 

Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
