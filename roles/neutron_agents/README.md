neutron_agents
=========

This role installs the neutron agents (OVS agent, DHCP agent, metadata agent) on a node. This requires the preparation of the following configuration files.

dhcp_agent.ini
metadata_agent.ini
openvswitch_agent.ini

The first configuration file that we need to create is the configuration for the DHCP agent.

* in the default section, we change the interface driver to match the ML2 agent
* we also define the DHCP agent driver itself
* we set the variable enable_isolated_metadata to true to also support metadata without any routers being present

The following changes are made to the configuration for the OVS agent (this is actually done by the dependency to the role ovs_agent that carries out the actual configuration)

* We define the bridge mappings, mapping our physical network to bridge names
* we define the firewall driver to use
* and we enable security groups

Finally, there is the configuration for the metadata agent.

* we need to specify the name of the node on which the nova server is running in nova_metadata_host
* we also need to specify the shared secret that is used to protect the traffic between the nova metadata server and neutron - this needs to be the same secret as in the nova configuration

In addition, the agents also need some of the configuration in the main configuration file neutron.conf. To allow the controller and network nodes to be on the same host, we use the same configuration for this file on both the network node and the controller node.




Requirements
------------

This assumes that Keystone is present and running and that the infrastructure components like MySQL and Rabbit are up and running

Role Variables
--------------

The following variables need to be set when calling this role.

* api_node - the name of the node on which Nova is running
* mq_node - the name of the node on which RabbitMQ is running
* db_node - the node on which the database is running
* memcached_node - the node on which Memcached is running
* rabbitmq_password- the password for RabbitMQ
* neutron_db_user_password - the password for the Neutron DB user
* neutron_keystone_user_password - the password for the Neutron user in Keystone
* nova_keystone_user_password - the password for the Nova user in Keystone
* metadata_shared_secret - the shared secret for the connection between the metadata proxy and Nova
* type_drivers - comma-separated list of the type driver that we want to support
* tenant_network_types - comma-separated list of network types that we make available as project networks, can be emtpy
* flat_networks - comma-separated list of flat networks that we provide
* ovs_bridge_mappings - OVS agent bridge mappings, like "physnet:br-phys". There needs to be one mapping for each network that we define

For the following variables, defaults are provided.

* service_plugins - list of service plugins to be included
* global_dns_servers - a list of DNS servers to use if no other DNS server is specified for a subnet

Dependencies
------------

This role has a dependency on ovs_agent to create the OVS agent configuration file and install the OVS agent


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
