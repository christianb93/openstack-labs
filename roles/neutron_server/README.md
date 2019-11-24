neutron_server
=========

This role installs the neutron-service on a controller node. We will install the neutron API server, the neutron ML2 plugin, the DHCP agent, the metadata agent and the OVS agent.

neutron.conf
ml2_conf.ini
dhcp_agent.ini
metadata_agent.ini
openvswitch_agent.ini

Let us start with neutron.conf. Here, we make the following changes to the sample file distributed with the package.

* in the default section, we change the auth_strategy to use keystone
* in the same section, we set the list of service_plugins to an empty list. These are advanced services like firewall-as-a-service or load-balancer-as-a-service that we will not need in this simple setup
* still in the defaults section, we set notify_nova_on_port_status_changes and notify_nova_on_port_data_changes so that neutron informes nova on status changes
* we set the transport_url to allow neutron to talk to our RabbitMQ server
* in the database section, define the connection string to connect to the neutron database
* in the section keystone_authtoken, we make the usual changes
* in the nova section, we provide the credentials for the nova user (!), which are used to inform Nova about the status changes (see above) using the Nova external events REST API
* in the oslo_concurrency section, we set the path to the directory in which lock files are stored


In the second configuration file which is used by the ML plugin, we need the following changes.

* we set the type_drivers field to a comma-separated list of the type drivers that we want to support.
* similarly, we set the list tenant_network_types of supported project network types
* in the ml section, we set the list of mechanism drivers. Here, we only use OVS
* in the same section, we set the list of extension drivers, installing the port security extension driver that enables us to turn off the default firewall rules for port security
* in the ml2_type_flat section, we define the list of flat networks that we support

The third configuration file that we need to create is the configuration for the DHCP agent.

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


Requirements
------------

This assumes that Keystone is present and running and that the infrastructure components like MySQL and Rabbit are up and running

Role Variables
--------------

The following variables need to be set when calling this role.

mysql_server_name - name of the node on which MySQL is running
keystone_server_name - the name of the node on which Keystone is running
rabbitmq_server_name - name of the node on which RabbitMQ is running
memcached_server_name - name of the node on which memcached is running
nova_server_name - name of the node on which Nova is running
keystone_admin_password - the password of the admin user in Keystone
neutron_keystone_user_password - the password of the neutron user in Keystone
neutron_db_user_password - the password that we assign to the neutron DB user
nova_keystone_user_password - the password of the nova user in keystone
rabbitmq_password - password of the openstack user in RabbitMQ
metadata_shared_secret - shared metadata secret, see nova configuration
type_drivers - comma-separated list of the type driver that we want to support
tenant_network_types - comma-separated list of network types that we make available as project networks, can be emtpy
flat_networks - comma-separated list of flat networks that we provide
ovs_bridge_mappings - OVS agent bridge mappings, like "physnet:br-phys". There needs to be one mapping for each network that we define

For the following variables, defaults are defined

network_vlan_ranges - physical networks available for VLAN networks and ranges available for tenant networks 

Dependencies
------------

This role has a dependency on ovs_agent to create the OVS agent configuration file and install the OVS agent


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
