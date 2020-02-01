neutron_server
=========

This role installs the neutron-service on a controller node. We will install the neutron API server and the neutron ML2 plugin. This implies that the following configuration needs to be maintained.

neutron.conf
ml2_conf.ini

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



Requirements
------------

This assumes that Keystone is present and running and that the infrastructure components like MySQL and Rabbit are up and running

Role Variables
--------------

The following variables need to be set when calling this role.

* mq_node - name of the node on which RabbitMQ is running
* db_node - name of the node on which MySQL is running
* neutron_keystone_user_password - the password of the neutron user in Keystone
* neutron_db_user_password - the password that we assign to the neutron DB user
* nova_keystone_user_password - the password of the nova user in keystone
* rabbitmq_password - password of the openstack user in RabbitMQ
* api_node - the name of the node on which Keystone is running
* memcached_node - name of the node on which memcached is running
* flat_networks - comma-separated list of flat networks that we provide
* type_drivers - comma-separated list of the type driver that we want to support
* tenant_network_types - comma-separated list of network types that we make available as project networks, can be emtpy
* keystone_admin_password - the password of the admin user in Keystone


For the following variables, defaults are defined

* service_plugins - list of service plugins to use
* network_vlan_ranges - physical networks available for VLAN networks and ranges available for tenant networks 
* network_vxlan_ranges - list of ranges that can be used for the VXLAN ids of tenant networks
* physical_network_mtus - list of specific network to MTU mappings




License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
