neutron_compute
=========

This role installs the neutron components on a compute node. It uses a dependency to ovs_agent to install the OVS agent itself and the openvswitch_agent.ini file. It then creates a neutron.conf file and restarts the services.



In neutron.conf, we make the following changes to the sample file distributed with the package.

* we set the transport_url to allow neutron to talk to our RabbitMQ server
* in the default section, we change the auth_strategy to use keystone
* in the section keystone_authtoken, we make the usual changes
* in the oslo_concurrency section, we set the path to the directory in which lock files are stored
* we comment out all database connections as the compute nodes do not connect directly to the database


Requirements
------------

This assumes that Keystone is present and running and that the infrastructure components like MySQL and Rabbit are up and running

Role Variables
--------------

The following variables need to be set when calling this role.

* api_node - the name of the node on which Keystone is running
* mq_node - name of the node on which RabbitMQ is running
* memcached_node - name of the node on which memcached is running
* keystone_admin_password - the password of the admin user in Keystone
* neutron_keystone_user_password - the password of the neutron user in Keystone
* rabbitmq_password - password of the openstack user in RabbitMQ
* type_drivers - comma-separated list of the type driver that we want to support
* tenant_network_types - comma-separated list of network types that we make available as project networks, can be emtpy
* flat_networks - comma-separated list of flat networks that we provide
* ovs_bridge_mappings - OVS agent bridge mappings, like "physnet:br-phys". There needs to be one mapping for each network that we define

Dependencies
------------

This role has a dependency on ovs_agent to create the OVS agent configuration file and install the OVS agent


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
