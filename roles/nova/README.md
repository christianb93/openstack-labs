nova
=========

This role installs the nova service on a node. The following configuration are done compared to the packaged version of the configuration file (nova.conf)

* we set the IP on which the Nova services will be listening to the management IP of the controller node (taken from an inventory variable) - this is done by adjusting *osapi_compute_listen* for the core API and *metadata_listen* for the metadata API
* similarly, we set *novncproxy_listen* to the management IP so that the noVNC proxy will listen on the management interface as well
* we set use_neutron = true to ask Nova to use Neutron instead of the deprecated nova-network
* we set the firewall_driver to nova.virt.firewall.NoopFirewallDriver to disable it (as described in the comments in the sample configuration)
* we set the transport_url to connect to the RabbitMQ server on the MQ node node using the user openstack and its password
* in the section api, we set the auth_strategy to keystone so that the Nova API service uses Keystone for authentication
* in the section api_database, we provide the connection string to the MySQL database Nova API for the nova user
* in the database section, we provide the connection to the nova database
* in the keystone_authtoken section, we provide the necessary information to use Keystone tokens
* in the neutron section, we provide connection and authorization settings for the neutron service and the metadata proxy service, including a shared secret
* in the oslo_concurrency section, we define a path which is used for lock files
* in the placement section, we define the information that Nova needs to authenticate against the placement service
* finally, we set resume_guests_state_on_host_boot to true to allow Nova to restart instances on a reboot

Requirements
------------

This assumes that Keystone is present and running and that the infrastructure components like MySQL and Rabbit are up and running

Role Variables
--------------

The following variables need to be set when calling this role.

* api_node - the name of node on which Keystone is running  
* memcached_node - the name of the node on which memcached is running
* db_node - the name of the node on which MySQL is running
* mq_node - the name on which the RabbitMQ service is running
* neutron_keystone_user_password - the password of the neutron Keystone user
* rabbitmq_password - the password to use for the openstack user in RabbitMQ
* keystone_admin_password - the password of the admin user in keystone
* nova_db_user_password - password that we will use for the nova DB user
* nova_keystone_user_password - the password that we will set for the nova user in Keystone
* placement_keystone_user_password - the password of the placement Keystone user
* metadata_shared_secret - a secret shared between Nova and Neutron for metadata proxy requests

For the following variable, a default is defined. 

* cinder_os_region_name - name of the region that Nova uses when looking for a cinder service, set this to the region name used for the cinder configuration when you want to use cinder


Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
