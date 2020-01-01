cinder
=========

This role installs the Cinder control plane (Cinder API, Cinder scheduler) on a node. We create a cinder DB user, a cinder Keystone user, services for both the v2 API and the v3 API and the respective endpoints. We then install the APT packages and modify the default cinder.conf files as follows.

* set the DB connection string
* the URL for the connection to RabbitMQ
* remove the configuration items iscsi-helper, volume_name_template, volume_group from the default section as they are apparently not used anymore (and reappear in the lvm section) or have reasonable defaults
* add connection information for the database and the RabbitMQ infrastructure
* provide the data required for the Keystone authtoken plugin
* set the IP address of the host to the IP address of the management interface



Requirements
------------

This assumes that Keystone is present and running

Role Variables
--------------

The following variables need to be set when calling this role.

* api_node - the name of node on which Keystone is running  
* db_node - the name of the node on which MySQL is running
* cinder_db_user_password - password that we will use for the cinder DB user
* cinder_keystone_user_password - the password that we will set for the cinder user in Keystone
* keystone_admin_password - the password of the admin user in keystone
* rabbitmq_password - the password of the RabbitMQ user
* mq_node - the node on which RabbitMQ is running
* memcached_node - name of the server on which memcached is running





Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
